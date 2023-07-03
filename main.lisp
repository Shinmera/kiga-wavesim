(in-package #:org.tymoonnext.kiga.wavesim)

(defvar *thread* NIL)
(defvar *env*)
(defparameter *window-size* 500)
(defparameter *granularity* 7)
(defparameter *spacing* 3)

(defun process ()
  (advance *env*))

(defun color-value (val)
  (let ((rval (- 255 (max 0 (min 255 (abs val))))))
    (if (< val 0)
        (sdl:color :r rval :g rval :b 255)
        (sdl:color :r 255 :g rval :b rval))))

(defun draw ()
  ;; Optimization possibility: Combine process and draw
  ;; so iteration only has to occur once. Makes code ugly
  ;; though, so I'll leave it for now.
  (sdl:clear-display (sdl:color :r 255 :g 255 :b 255))
  (dotimes (y (array-dimension (current *env*) 0))
    (dotimes (x (array-dimension (current *env*) 0))
      (sdl:draw-box-* (floor (+ (* *granularity* x) (/ *spacing* 2)))
                      (floor (+ (* *granularity* y) (/ *spacing* 2)))
                      (- *granularity* *spacing*) (- *granularity* *spacing*)
                      :color (color-value (aref (current *env*) y x)))))
  (dolist (wall (walls *env*))
    (sdl:draw-box-* (floor (+ (* *granularity* (x wall)) (/ *spacing* 2)))
                    (floor (+ (* *granularity* (y wall)) (/ *spacing* 2)))
                    (floor (- (* *granularity* (w wall)) (/ *spacing* 2)))
                    (floor (- (* *granularity* (h wall)) (/ *spacing* 2)))
                    :color (sdl:color))))

(defun start ()
  (let ((*env* (make-instance 'wave-environment :width (floor (/ *window-size* *granularity*))
                                                :height (floor (/ *window-size* *granularity*))))
        (startx NIL) (curx NIL)
        (starty NIL) (cury NIL))
    (sdl:with-init ()
      (sdl:window *window-size* *window-size* :title-caption "Kiga Wavesim")
      (sdl:update-display)
      (sdl:with-events ()
        (:quit-event () T)
        (:mouse-button-down-event (:x x :y y :button button)
          (when (eql button sdl:sdl-button-right)
            (setf startx x starty y)))
        (:mouse-button-up-event (:x x :y y :button button)
          (if (eql button sdl:sdl-button-left)
              (start-wave *env*
                          (1+ (floor (/ x *granularity*)))
                          (1+ (floor (/ y *granularity*)))
                          1000.0)
              (when startx
                (make-wall *env*
                           (1+ (floor (/ startx *granularity*)))
                           (1+ (floor (/ starty *granularity*)))
                           (1+ (floor (/ (- x startx) *granularity*)))
                           (1+ (floor (/ (- y starty) *granularity*))))
                (setf startx NIL starty NIL))))
        (:mouse-motion-event (:x x :y y)
          (setf curx x cury y))
        (:idle ()
          (process)
          (draw)
          (when startx
            (sdl:draw-box-* startx starty (- curx startx) (- cury starty) :color (sdl:color :r 255 :g 235 :b 0)))
          (sdl:update-display))))))

(defun start-threaded ()
  (setf *thread*
        (bordeaux-threads:make-thread #'start :initial-bindings `((*standard-output* . ,*standard-output*)))))
