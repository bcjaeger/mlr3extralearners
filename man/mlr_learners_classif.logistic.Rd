% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/learner_RWeka_classif_logistic.R
\name{mlr_learners_classif.logistic}
\alias{mlr_learners_classif.logistic}
\alias{LearnerClassifLogistic}
\title{Classification Logistic Regression Learner}
\description{
Multinomial Logistic Regression model with a ridge estimator.
Calls \code{\link[RWeka:Weka_classifier_functions]{RWeka::Logistic()}} from \CRANpkg{RWeka}.
}
\section{Custom mlr3 parameters}{

\itemize{
\item \code{output_debug_info}:
\itemize{
\item original id: output-debug-info
}
\item \code{do_not_check_capabilities}:
\itemize{
\item original id: do-not-check-capabilities
}
\item \code{num_decimal_places}:
\itemize{
\item original id: num-decimal-places
}
\item \code{batch_size}:
\itemize{
\item original id: batch-size
}
\item Reason for change: This learner contains changed ids of the following control arguments
since their ids contain irregular pattern
}
}

\section{Dictionary}{

This \link{Learner} can be instantiated via the \link[mlr3misc:Dictionary]{dictionary} \link{mlr_learners} or with the associated sugar function \code{\link[=lrn]{lrn()}}:

\if{html}{\out{<div class="sourceCode">}}\preformatted{mlr_learners$get("classif.logistic")
lrn("classif.logistic")
}\if{html}{\out{</div>}}
}

\section{Meta Information}{

\itemize{
\item Task type: \dQuote{classif}
\item Predict Types: \dQuote{response}, \dQuote{prob}
\item Feature Types: \dQuote{logical}, \dQuote{integer}, \dQuote{numeric}, \dQuote{factor}, \dQuote{ordered}
\item Required Packages: \CRANpkg{mlr3}, \CRANpkg{RWeka}
}
}

\section{Parameters}{
\tabular{lllll}{
   Id \tab Type \tab Default \tab Levels \tab Range \cr
   subset \tab untyped \tab - \tab  \tab - \cr
   na.action \tab untyped \tab - \tab  \tab - \cr
   C \tab logical \tab FALSE \tab TRUE, FALSE \tab - \cr
   R \tab numeric \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   M \tab integer \tab -1 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   output_debug_info \tab logical \tab FALSE \tab TRUE, FALSE \tab - \cr
   do_not_check_capabilities \tab logical \tab FALSE \tab TRUE, FALSE \tab - \cr
   num_decimal_places \tab integer \tab 2 \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   batch_size \tab integer \tab 100 \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   options \tab untyped \tab NULL \tab  \tab - \cr
}
}

\examples{
learner = mlr3::lrn("classif.logistic")
print(learner)

# available parameters:
learner$param_set$ids()
}
\references{
le Cessie, S., van Houwelingen, J.C. (1992).
\dQuote{Ridge Estimators in Logistic Regression.}
\emph{Applied Statistics}, \bold{41}(1), 191-201.
}
\seealso{
\itemize{
\item \link[mlr3misc:Dictionary]{Dictionary} of \link[mlr3:Learner]{Learners}: \link[mlr3:mlr_learners]{mlr3::mlr_learners}.
\item \code{as.data.table(mlr_learners)} for a table of available \link[=Learner]{Learners} in the running session (depending on the loaded packages).
\item Chapter in the \href{https://mlr3book.mlr-org.com/}{mlr3book}: \url{https://mlr3book.mlr-org.com/basics.html#learners}
\item \CRANpkg{mlr3learners} for a selection of recommended learners.
\item \CRANpkg{mlr3cluster} for unsupervised clustering learners.
\item \CRANpkg{mlr3pipelines} to combine learners with pre- and postprocessing steps.
\item \CRANpkg{mlr3tuning} for tuning of hyperparameters, \CRANpkg{mlr3tuningspaces} for established default tuning spaces.
}
}
\author{
damirpolat
}
\section{Super classes}{
\code{\link[mlr3:Learner]{mlr3::Learner}} -> \code{\link[mlr3:LearnerClassif]{mlr3::LearnerClassif}} -> \code{LearnerClassifLogistic}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-LearnerClassifLogistic-new}{\code{LearnerClassifLogistic$new()}}
\item \href{#method-LearnerClassifLogistic-clone}{\code{LearnerClassifLogistic$clone()}}
}
}
\if{html}{\out{
<details><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="base_learner"><a href='../../mlr3/html/Learner.html#method-Learner-base_learner'><code>mlr3::Learner$base_learner()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="format"><a href='../../mlr3/html/Learner.html#method-Learner-format'><code>mlr3::Learner$format()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="help"><a href='../../mlr3/html/Learner.html#method-Learner-help'><code>mlr3::Learner$help()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="predict"><a href='../../mlr3/html/Learner.html#method-Learner-predict'><code>mlr3::Learner$predict()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="predict_newdata"><a href='../../mlr3/html/Learner.html#method-Learner-predict_newdata'><code>mlr3::Learner$predict_newdata()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="print"><a href='../../mlr3/html/Learner.html#method-Learner-print'><code>mlr3::Learner$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="reset"><a href='../../mlr3/html/Learner.html#method-Learner-reset'><code>mlr3::Learner$reset()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="train"><a href='../../mlr3/html/Learner.html#method-Learner-train'><code>mlr3::Learner$train()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-LearnerClassifLogistic-new"></a>}}
\if{latex}{\out{\hypertarget{method-LearnerClassifLogistic-new}{}}}
\subsection{Method \code{new()}}{
Creates a new instance of this \link[R6:R6Class]{R6} class.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{LearnerClassifLogistic$new()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-LearnerClassifLogistic-clone"></a>}}
\if{latex}{\out{\hypertarget{method-LearnerClassifLogistic-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{LearnerClassifLogistic$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
