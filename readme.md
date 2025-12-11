# Docs generation for 2P and widefield Ca<sup>2+</sup> imaging (on Sutter Rig)
- uses `mkdocs` for git tracked documentation

## Link to live site
- [2PCI_setup](https://xiubert.github.io/2PCI_setup)

## Setup
1. Clone repository `https://github.com/xiubert/Ca2plusDocs.git` and change to respository directory (`cd Ca2plusDocs`).
2. Create python venv for running these scripts to isolate dependencies: `python -m venv env`
3. Activate virtual environment:
    - Unix: `source env/bin/activate`
    - Windows: 
        - VSCode terminal defaults to PowerShell: `.\env\Scripts\Activate.ps1`
        - If in command prompt `.\env\bin\activate.bat`
4. Install dependencies: `pip install -r requirements.txt`
5. ~~Create new project (DONE)~~: ~~`mkdocs new Ca2plusDocs`~~

## Serve site locally
- `mkdocs serve`

## Deploy site
- `mkdocs gh-deploy` (same for updates)