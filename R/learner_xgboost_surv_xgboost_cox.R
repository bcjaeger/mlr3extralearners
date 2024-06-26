#' @title Extreme Gradient Boosting Cox Survival Learner
#' @author bblodfon
#' @name mlr_learners_surv.xgboost.cox
#'
#' @description
#' eXtreme Gradient Boosting regression using a **Cox Proportional Hazards**
#' objective.
#' Calls [xgboost::xgb.train()] from package \CRANpkg{xgboost} with `objective`
#' set to `survival:cox` and `eval_metric` to `cox-nloglik` by default.
#'
#' @details
#' Three types of prediction are returned for this learner:
#' 1. `lp`: a vector of linear predictors (relative risk scores), one per
#' observation.
#' 2. `crank`: same as `lp`.
#' 3. `distr`: a survival matrix in two dimensions, where observations are
#' represented in rows and time points in columns.
#' By default, the Breslow estimator is used via [mlr3proba::breslow()].
#'
#' @template note_xgboost
#'
#' @section Initial parameter values:
#' - `nrounds` is initialized to 1.
#' - `nthread` is initialized to 1 to avoid conflicts with parallelization via \CRANpkg{future}.
#' - `verbose` is initialized to 0.
#'
#' @templateVar id surv.xgboost.cox
#' @template learner
#' @template section_early_stopping
#'
#' @references
#' `r format_bib("chen_2016")`
#'
#' @template seealso_learner
#' @template example
#' @export
LearnerSurvXgboostCox = R6Class("LearnerSurvXgboostCox",
  inherit = mlr3proba::LearnerSurv,
  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        alpha                       = p_dbl(0, default = 0, tags = "train"),
        base_score                  = p_dbl(default = 0.5, tags = "train"),
        booster                     = p_fct(c("gbtree", "gblinear", "dart"), default = "gbtree", tags = "train"),
        callbacks                   = p_uty(default = list(), tags = "train"),
        colsample_bylevel           = p_dbl(0, 1, default = 1, tags = "train"),
        colsample_bynode            = p_dbl(0, 1, default = 1, tags = "train"),
        colsample_bytree            = p_dbl(0, 1, default = 1, tags = "train"),
        disable_default_eval_metric = p_lgl(default = FALSE, tags = "train"),
        early_stopping_rounds       = p_int(1L, default = NULL, special_vals = list(NULL), tags = "train"),
        early_stopping_set          = p_fct(c("none", "train", "test"), default = "none", tags = "train"),
        eta                         = p_dbl(0, 1, default = 0.3, tags = "train"),
        feature_selector            = p_fct(c("cyclic", "shuffle", "random", "greedy", "thrifty"), default = "cyclic", tags = "train"), #nolint
        feval                       = p_uty(default = NULL, tags = "train"),
        gamma                       = p_dbl(0, default = 0, tags = "train"),
        grow_policy                 = p_fct(c("depthwise", "lossguide"), default = "depthwise", tags = "train"),
        interaction_constraints     = p_uty(tags = "train"),
        iterationrange              = p_uty(tags = "predict"),
        lambda                      = p_dbl(0, default = 1, tags = "train"),
        lambda_bias                 = p_dbl(0, default = 0, tags = "train"),
        max_bin                     = p_int(2L, default = 256L, tags = "train"),
        max_delta_step              = p_dbl(0, default = 0, tags = "train"),
        max_depth                   = p_int(0L, default = 6L, tags = "train"),
        max_leaves                  = p_int(0L, default = 0L, tags = "train"),
        maximize                    = p_lgl(default = NULL, special_vals = list(NULL), tags = "train"),
        min_child_weight            = p_dbl(0, default = 1, tags = "train"),
        missing                     = p_dbl(default = NA, tags = c("train", "predict"), special_vals = list(NA, NA_real_, NULL)), #nolint
        monotone_constraints        = p_int(-1L, 1L, default = 0L, tags = "train"),
        normalize_type              = p_fct(c("tree", "forest"), default = "tree", tags = "train"),
        nrounds                     = p_int(1L, tags = "train"),
        nthread                     = p_int(1L, default = 1L, tags = c("train", "threads")),
        num_parallel_tree           = p_int(1L, default = 1L, tags = "train"),
        one_drop                    = p_lgl(default = FALSE, tags = "train"),
        print_every_n               = p_int(1L, default = 1L, tags = "train"),
        process_type                = p_fct(c("default", "update"), default = "default", tags = "train"),
        rate_drop                   = p_dbl(0, 1, default = 0, tags = "train"),
        refresh_leaf                = p_lgl(default = TRUE, tags = "train"),
        sampling_method             = p_fct(c("uniform", "gradient_based"), default = "uniform", tags = "train"),
        sample_type                 = p_fct(c("uniform", "weighted"), default = "uniform", tags = "train"),
        save_name                   = p_uty(tags = "train"),
        save_period                 = p_int(0L, tags = "train"),
        scale_pos_weight            = p_dbl(default = 1, tags = "train"),
        seed_per_iteration          = p_lgl(default = FALSE, tags = "train"),
        skip_drop                   = p_dbl(0, 1, default = 0, tags = "train"),
        strict_shape                = p_lgl(default = FALSE, tags = "predict"),
        subsample                   = p_dbl(0, 1, default = 1, tags = "train"),
        top_k                       = p_int(0, default = 0, tags = "train"),
        tree_method                 = p_fct(c("auto", "exact", "approx", "hist", "gpu_hist"), default = "auto", tags = "train"), #nolint
        tweedie_variance_power      = p_dbl(1, 2, default = 1.5, tags = "train"),
        updater                     = p_uty(tags = "train"), # Default depends on the selected booster
        verbose                     = p_int(0L, 2L, default = 1L, tags = "train"),
        watchlist                   = p_uty(default = NULL, tags = "train"),
        xgb_model                   = p_uty(tags = "train"),
        device                      = p_uty(tags = "train")
      )
      # param deps
      ps$add_dep("print_every_n", "verbose", CondEqual$new(1L))
      ps$add_dep("sample_type", "booster", CondEqual$new("dart"))
      ps$add_dep("normalize_type", "booster", CondEqual$new("dart"))
      ps$add_dep("rate_drop", "booster", CondEqual$new("dart"))
      ps$add_dep("skip_drop", "booster", CondEqual$new("dart"))
      ps$add_dep("one_drop", "booster", CondEqual$new("dart"))
      ps$add_dep("tree_method", "booster", CondAnyOf$new(c("gbtree", "dart")))
      ps$add_dep("grow_policy", "tree_method", CondEqual$new("hist"))
      ps$add_dep("max_leaves", "grow_policy", CondEqual$new("lossguide"))
      ps$add_dep("max_bin", "tree_method", CondEqual$new("hist"))
      ps$add_dep("feature_selector", "booster", CondEqual$new("gblinear"))
      ps$add_dep("top_k", "booster", CondEqual$new("gblinear"))
      ps$add_dep("top_k", "feature_selector", CondAnyOf$new(c("greedy", "thrifty")))

      # custom defaults
      ps$values = list(nrounds = 1L, nthread = 1L, verbose = 0L, early_stopping_set = "none")

      super$initialize(
        id = "surv.xgboost.cox",
        param_set = ps,
        predict_types = c("crank", "lp", "distr"),
        feature_types = c("integer", "numeric"),
        properties = c("weights", "missings", "importance"),
        packages = c("mlr3extralearners", "xgboost"),
        man = "mlr3extralearners::mlr_learners_surv.xgboost.cox",
        label = "Extreme Gradient Boosting Cox"
      )
    },

    #' @description
    #' The importance scores are calculated with [xgboost::xgb.importance()].
    #'
    #' @return Named `numeric()`.
    importance = function() {
      xgb_imp(self$model$model)
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")
      # manually add 'objective' and 'eval_metric'
      pv = c(pv, objective = "survival:cox", eval_metric = "cox-nloglik")

      data = get_xgb_mat(task, objective = pv$objective)

      if ("weights" %in% task$properties) {
        xgboost::setinfo(data, "weight", task$weights$weight)
      }

      # XGBoost uses the last element in the watchlist as
      # the early stopping set
      if (pv$early_stopping_set != "none") {
        pv$watchlist = c(pv$watchlist, list(train = data))
      }

      if (pv$early_stopping_set == "test" && !is.null(task$row_roles$test)) {
        test_data = get_xgb_mat(task, pv$objective, task$row_roles$test)
        pv$watchlist = c(pv$watchlist, list(test = test_data))
      }
      pv$early_stopping_set = NULL

      list(
        model = invoke(xgboost::xgb.train, data = data, .args = pv),
        train_data = data # for breslow
      )
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      # manually add 'objective'
      pv = c(pv, objective = "survival:cox")

      model = self$model$model
      newdata = as_numeric_matrix(ordered_features(task, self))
      # linear predictor on the test set
      lp_test = log(invoke(
        predict, model,
        newdata = newdata,
        .args = pv
      ))

      # linear predictor on the train set
      train_data = self$model$train_data
      lp_train = log(invoke(
        predict, model,
        newdata = train_data,
        .args = pv,
      ))

      # extract (times, status) from train data
      truth = xgboost::getinfo(train_data, "label")
      times = abs(truth)
      status = as.integer(truth > 0) # negative times => censored
      surv = mlr3proba::breslow(times = times, status = status,
                                lp_train = lp_train, lp_test = lp_test)

      mlr3proba::.surv_return(surv = surv, crank = lp_test, lp = lp_test)
    }
  )
)

.extralrns_dict$add("surv.xgboost.cox", LearnerSurvXgboostCox)
