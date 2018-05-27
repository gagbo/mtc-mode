;;; mtc-mode.el --- simple major mode for editing MTC files
;; -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright © 2018, by Gerry Agbobada

;; Author: Gerry Agbobada ( gagbobada+git@gmail.com )
;; Version: 0.0.1
;; Created: 27 May 2018
;; Keywords: languages
;; Homepage: http://cemef.mines-paristech.fr

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the MIT License

;;; Commentary:

;; Major mode for editing mtc files, scripts used by Cimlib

;; The mode should load automatically on .mtc extension

;;; Code:

;; create the list for font-lock
;; each category of keyword is given a particular face

(defvar mtc-font-lock-keywords nil "Keywords highlights for mtc-mode.")

(setq mtc-font-lock-keywords
      (let* (
             (x-mtc-assign '(
                             ;; Usual assignments
                             "Type=" "Data="  "Entite=" "Dimension="
                             "Degres=" "Min=" "Max=" "Valeurs=" "Priorite="
                             "OperationsP1=" "Origine=" "Axes=" "NbChampsP1="
                             "NbChamps=" "Numero=" "Initialise=" "Operateur="
                             "Boucle=" "Fonction=" "NomCompteur="
                             "NbChampSolution=" "NbChampParametre=" "Champ:"
                             "ChampCondition=" "ObjetChamp=" "Operation="
                             "Operations=" "Affichage=" "EcrirePartition="
                             "SortieParElement="
                             ;; Data related assign
                             "NomFrequence=" "NomFichier=" "NomFichier:"
                             "TypeFichier="
                             ;; Mesh related assign
                             "M:" "Partitionnement=" "Scripts=" "Remaillage="
                             "Decale=" "Repartitionne="
                             ;; Adaptation related assign
                             "RAdaptation=" "Old=" "New=" "HAdaptation="
                             "Effectue=" "Taille=" "Metrique=" "Qualite="
                             "QualiteMin=" "Transport=" "Brique=" "TailleMax="
                             "CreationNoeuds=" "DestructionNoeuds="
                             ;; Fitz related assign
                             "Fitz=" "TamponMetrique=" "LevelSets="
                             "LevelSetsMultiple=" "PhaseModes="
                             "PointPrecision=" "VolumePrecision="
                             "QualityPrecision=" "YieldQuality="
                             "PhasePrecision=" "IterationsMax="
                             "NoeudsBloques=" "ElementsBloques=" "Cracks="
                             "CracksMultiples=" "FiltresCracks="
                             ;; Solveur related assign
                             "Precision=" "IterMax=" "Resolution="
                             "Preconditionneur=" "Methode=" "Implicite="
                             "Galerkin=" "Thermique=" "PointFixe="
                             "EpsRegularisation="
                             ;; Geometre related assign
                             "Forme=" "Centre=" "NormaleSortante=" "Normale="
                             "Repere=" "Rayon="
                             ))
             (x-mtc-appel '(
                            "Target=" "ChampParametre=" "ChampSolution="
                            "ChampParametres=" "Geometre=" "Repere=" "Champ="
                            "Appartient=" "NomTemps=" "NomPasDeTemps="
                            "NomTempsFin="
                            ))
             (x-mtc-decla '( "Nom=" ))
             (x-lanceur '( "Lanceur=" ))
             (x-mtc-type '(
                           ;; VChamp types
                           "P1_Vecteur_Par" "P1_Scalaire_Par" "P1_Tenseur_Par"
                           "P1_Tenseur_Sym_Par" "P0_Vecteur_Par"
                           "P0_Scalaire_Par" "P0_Tenseur_Par"
                           "P0_Tenseur_Sym_Par" "P0C_Scalaire_Par"
                           "P0C_Vecteur_Par"  "P0C_Tenseur_Par"
                           ;; Declaration of VChamp values
                           "ValeurItem"
                           ;; Declaration of CL or Geometre types
                           "ModeleCLSurGeometres" "CLDirichlet"
                           "GeometreAnalytique" "GeometreChamp" "Boule"
                           "DemiPlan" "Brique"
                           ;; I/O types
                           "SortieVtu" "SortieVtuB"
                           "SortieVtk" "SortieVtf" "SortieMtc" "SortieXdmf"
                           "EntreeVtu" "EntreeVtuB"
                           ))
             (x-mtc-modele '(
                             ;; Types for Modele=
                             "ModeleParticulaire" "ModeleFonctionnel"
                             "ModeleDeChamps" "ModeleElementsFinis"
                             "ModeleMaillage" "ModeleConstant"
                             "ModeleDeModeles" "ModeleSortie"
                             "ModeleCLSurChamps" "ModeleArithmetique"
                             "ModeleConditionnel" "ModeleDeGeometres"
                             "ModeleDeMouvements" "ModeleAnalytique"
                             "ModeleComportement" "ModelePostProcess"
                             "ModeleIncremental" "ModeleTemporel"
                             "ModeleFinSurTemps" "ModeleReprise"
                             ))
             (x-mtc-modele-arg '(
                                 ;; Named arguments for Modele
                                 "SimplexSolveurFonctionnel=" "ItemSolveur="
                                 "SolveurLocal=" "Solveur=" "Dependance="
                                 "DependanceModifiable=" "DependanceAEcrire="
                                 "DependanceALire=" "nextgroup=mtcData" "skipwhite"
                                 "Maillage=" "nextgroup=mtcData" "skipwhite"
                                 "Modele=" "ModeleIncrement=" "ModeleTerminaison="
                                 "ModeleApresFin=" "ModeleAvantDebut="
                                 "ModeleTrue=" "ModeleFalse=" "ModeleCL="
                                 "ModeleLoi=" "ConditionLimite="
                                 ))
             ;; generate regex string for each category
             (x-mtc-assign-regexp (regexp-opt x-mtc-assign 'words))
             (x-mtc-appel-regexp (regexp-opt x-mtc-appel 'words))
             (x-mtc-decla-regexp (regexp-opt x-mtc-decla 'words))
             (x-lanceur-regexp (regexp-opt x-lanceur 'words))
             (x-mtc-type-regexp (regexp-opt x-mtc-type 'words))
             (x-mtc-modele-regexp (regexp-opt x-mtc-modele 'words))
             (x-mtc-mod-arg-regexp (regexp-opt x-mtc-modele-arg 'words)))
        `(
          (,x-lanceur-regexp . font-lock-preprocessor-face)
          (,x-mtc-decla-regexp . font-lock-builtin-face)
          (,x-mtc-assign-regexp . font-lock-keyword-face)
          (,x-mtc-type-regexp . font-lock-type-face)
          (,x-mtc-modele-regexp . font-lock-function-name-face)
          (,x-mtc-mod-arg-regexp . font-lock-builtin-face)
          (,x-mtc-appel-regexp . font-lock-builtin-face)
          ("\\([a-zA-Z0-9-_]+?.mtc\\)" . (1 font-constant-face))
          ("\\([a-zA-Z0-9-_]+?.t\\)" . (1 font-constant-face))
          ("\\(-?[0-9]+?\\([eE][+-]?[0-9]+?\\)?\\)" . (1 font-constant-face))
          ("{\\([^}]+?\\)}" . (1 font-variable-name-face))
    )))


(defvar mtc-mode-syntax-table nil "Syntax table for 'mtc-mode'.")

(setq mtc-mode-syntax-table
      (let ( (synTable (make-syntax-table)))
        ;; C++ style comment “// …”
        (modify-syntax-entry ?\/ ". 12b" synTable)
        (modify-syntax-entry ?\n "> b" synTable)
        synTable))

(define-derived-mode mtc-mode fundamental-mode "MTC script"
                     "Major mode for editing mtc scripts (Cemef's Cimlib interface)..."
                     ;; code for syntax highlighting
                     (setq-local font-lock-defaults '((mtc-font-lock-keywords)))
                     (setq-local comment-start "//")
                     (setq-local comment-end "")
                     )

(provide 'mtc-mode)

;;; mtc-mode.el ends here
