;mhl-colour-exchange-on-all-layers.scm
;==============================================================================
;MHL-Colour Exchange on All Layers
;
;Swap one colour with another on several layers
;
;Copyright (C) 2019 Melon (https://github.com/Mhlov)
;
; LICENSE
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;==============================================================================
;Tested on GIMP 2.10.18

(define (mhl-ceoal-get-linked-flag item
								   linked-only)
	(if 
	  (or
		(and (= TRUE linked-only)
			 (= TRUE (car (gimp-item-get-linked item))))
		(= FALSE linked-only))
	  FALSE
	  TRUE))

(define (mhl-ceoal-get-group-layers group
									visible-only
									linked-only)
  (define layers '())

  (for-each

	(lambda (layer)
	  (if
		(or
		  (and (= TRUE visible-only)
			   (= TRUE (car (gimp-item-get-visible layer))))
		  (= FALSE visible-only))
		(if
		  (= TRUE (car (gimp-item-is-group layer)))
		  ; than
		  (set! layers
			(append layers
					(mhl-ceoal-get-group-layers
					  layer
					  visible-only
					  (mhl-ceoal-get-linked-flag layer
												 linked-only))))
		  ; else
		  (if
			(or
			  (and (= TRUE linked-only)
				   (= TRUE (car (gimp-item-get-linked layer))))
			  (= FALSE linked-only))
			(set! layers (append layers
								 (list layer)))))))

	; list of layers in a group
	(vector->list (cadr (gimp-item-get-children group))))

  layers)

(define (mhl-ceoal-get-layers image
							  visible-only
							  linked-only)
  (define layers '())

  (for-each

	(lambda (layer)
	  (if
		(or
		  (and (= TRUE visible-only)
			   (= TRUE (car (gimp-item-get-visible layer))))
		  (= FALSE visible-only))
		(if
		  ( = TRUE (car (gimp-item-is-group layer)))
		  ;than
		  (set! layers
			(append layers
					(mhl-ceoal-get-group-layers
					  layer
					  visible-only
					  (mhl-ceoal-get-linked-flag layer
												 linked-only))))
		  ;else
		  (if
			(or
			  (and (= TRUE linked-only)
				   (= TRUE (car (gimp-item-get-linked layer))))
			  (= FALSE linked-only))
			(set! layers (append layers
								 (list layer)))))))

	; list of layers in the image
	(vector->list (cadr (gimp-image-get-layers image))))

  layers)


(define (mhl-ceoal image
				   first-color
				   second-color
				   visible-only
				   linked-only)

  ; Start of the undo group
  (gimp-image-undo-group-start image)

  (for-each (lambda (layer)
					(plug-in-exchange 1
									  image
									  layer
									  (car		first-color)
									  (cadr		first-color)
									  (caddr	first-color)
									  (car		second-color)
									  (cadr		second-color)
									  (caddr	second-color)
									  0 0 0))
			(mhl-ceoal-get-layers image
								  visible-only
								  linked-only))

  ; End of the undo group
  (gimp-image-undo-group-end image)

  ; Flush all internal changes to the user interface
  (gimp-displays-flush))


(script-fu-register "mhl-ceoal"
					_"<Image>/Script-Fu/MHL-Colour Exchange on All Layers"
                    "Swap one colour with another on several layers"
                    "MHL <mhl@localhost>"
                    "MHL"
                    "2020"
                    "*"
                    SF-IMAGE "Image" 0
					SF-COLOR "From colour" '(255 0 0)
					SF-COLOR "To colour" '(0 255 0)
					SF-TOGGLE "Visible layers only" TRUE
					SF-TOGGLE "Linked layers only" FALSE
)

