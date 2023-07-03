(defsystem wavesim
  :name "Simple Wave Simulator"
  :version "0.1.0"
  :license "Artistic"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "Two dimensional air wave simulator"
  :serial T
  :components ((:file "package")
               (:file "simulator")
               (:file "main"))
  :depends-on (:lispbuilder-sdl
               :bordeaux-threads))
