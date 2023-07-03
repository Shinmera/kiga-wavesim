(defpackage wavesim
  (:nicknames #:org.tymoonnext.kiga.wavesim)
  (:use #:cl)
  ;; simulator.lisp
  (:export
   #:wave-environment
   #:current
   #:advance
   #:start-wave)
  ;; main.lisp
  (:export
   #:*thread*
   #:*window-size*
   #:*granularity*
   #:*spacing*
   #:start
   #:start-threaded))
