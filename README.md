## Devoir 2 — Déploiement Multi‑environnement (Terraform)

Ce README décrit l'Exercice 3 du projet : déployer une infra Azure (VNet, Subnet, VM, ACR) pour trois environnements indépendants : `dev`, `integration`, `prod`.
## Objectif
## Arborescence principale (Ex3)
- `main.tf`, `variables.tf`, `outputs.tf`
- `dev.tfvars`, `integration.tfvars`, `prod.tfvars` (au root de `Ex3`)
- `environments/` (copies par env)
- `modules/` (network, compute, acr, acr_registry)
- `Exercices/Terraform/Ex3/.github/actions/terraform` (action composite réutilisable)
Ce projet a pour objectif de déployer une infrastructure Azure à l'aide de **Terraform** en gérant plusieurs environnements indépendants (Développement, Production et Intégration).
## Principaux points
- Ajout de l'environnement `integration`.
- Module ACR réutilisable et second ACR par environnement (`mon_acr_secondary`).
- Workflow GitHub Actions réutilisable gère `init/plan/apply/destroy` et remplace la clé d'état par `<env>.terraform.tfstate`.


## Utilisation GitHub Actions
- Workflow principal : `.github/workflows/terraform-ex3-deploy.yml` (dispatch manuel).
- L'action composite `Exercices/Terraform/Ex3/.github/actions/terraform/action.yml` effectue `init`, `plan` puis `apply/destroy` selon l'input.
- Secrets recommandés : `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, et (si nécessaire) backend config secrets.
---
## Sécurité
- Ne pas committer `admin_password` en clair. Utiliser GitHub Secrets, Azure Key Vault, ou variables d'environnement.

## Vérification rapide
- Les fichiers `dev.tfvars`, `integration.tfvars` et `prod.tfvars` existent à la racine de `Ex3`.
- Pour que `plan` fonctionne localement, assurez-vous d'être dans le bon dossier ou d'utiliser `-chdir`.
## Technologies utilisées
Souhaitez-vous que j'exécute `terraform plan -var-file=dev.tfvars` ici et partage la sortie ?

- Terraform
- Microsoft Azure
- Azure Storage (Backend Terraform)
- Azure Virtual Network
- Azure Virtual Machine
- Azure Container Registry (ACR)
- GitHub Actions

---

## Structure du projet

```
Ex3/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── dev.tfvars
├── integration.tfvars
├── prod.tfvars
├── modules/
│   ├── network/
│   ├── compute/
│   └── acr/
└── .github/
    └── workflows/
        └── terraform-ex3-deploy.yml
```

---

## Environnements
Le projet permet de déployer trois environnements indépendants :

EnvironnementFichier tfvarsBackend TerraformDevelopment`dev.tfvars``dev.terraform.tfstate`Integration`integration.tfvars``integration.terraform.tfstate`Production`prod.tfvars``prod.terraform.tfstate`Chaque environnement déploie :

- un Virtual Network
- un Subnet
- une Machine Virtuelle Linux
- un Azure Container Registry

---

## Backend Terraform
Le backend utilise un compte Azure Storage afin de conserver le fichier d'état Terraform.

Exemple :

```
backend "azurerm" {
  resource_group_name  = "<resource-group-backend>"
  storage_account_name = "<storage-account>"
  container_name       = "tfstate"
  key                  = "default.terraform.tfstate"
}
```
Lors du déploiement via GitHub Actions, la clé est automatiquement remplacée par :

- `dev.terraform.tfstate`
- `integration.terraform.tfstate`
- `prod.terraform.tfstate`

---

## Déploiement en local

### Initialisation

```
terraform init
```

### Plan
Développement

```
terraform plan -var-file="dev.tfvars"
```
Intégration

```
terraform plan -var-file="integration.tfvars"
```
Production

```
terraform plan -var-file="prod.tfvars"
```

### Déploiement
Développement

```
terraform apply -var-file="dev.tfvars"
```
Intégration

```
terraform apply -var-file="integration.tfvars"
```
Production

```
terraform apply -var-file="prod.tfvars"
```

### Suppression

```
terraform destroy -var-file="dev.tfvars"
```

---

## Déploiement via GitHub Actions
Le workflow est déclenché manuellement (`workflow_dispatch`).

Il permet de sélectionner :

- l'environnement (`dev`, `integration` ou `prod`)
- l'opération Terraform
Le pipeline exécute automatiquement :

1. `terraform init`
2. `terraform plan`
3. `terraform apply`
avec le fichier `.tfvars` correspondant à l'environnement choisi.

---

## Modules Terraform

### Network
Création des ressources réseau :

- Virtual Network
- Subnet

### Compute
Création des ressources de calcul :

- Public IP
- Network Interface
- Machine Virtuelle Linux

### Azure Container Registry
Création d'un registre privé Azure Container Registry pour chaque environnement.

---

## Prérequis
Avant l'exécution du projet, les éléments suivants doivent être disponibles :

- Un abonnement Microsoft Azure
- Un Resource Group pour le backend
- Un Storage Account
- Un conteneur Blob nommé `tfstate`
- Terraform installé
- Azure CLI installé
- Authentification Azure (`az login`)
Pour GitHub Actions, les secrets suivants doivent être configurés :

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

---

## Auteur
Projet réalisé dans le cadre du module **Cloud Computing** – Bachelor Informatique. fais moi ça 