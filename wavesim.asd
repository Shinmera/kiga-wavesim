#|
 This file is a part of Wavesim
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defsystem wavesim
  :name "Simple Wave Simulator"
  :version "0.1.0"
  :license "Artistic"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :description "Two dimensional air wave simulator"
  :serial T
  :components ((:file "package")
               (:file "simulator")
               (:file "main"))
  :depends-on (:lispbuilder-sdl
               :bordeaux-threads))
