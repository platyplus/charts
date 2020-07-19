# TODO helm dependencies update
helm package source/*
helm repo index --url https://charts.platyplus.io .
