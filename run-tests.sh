#!/bin/bash
# Wrapper pour lancer les tests avec le bon environnement

# Activer Java 17
source ~/.sdkman/bin/sdkman-init.sh
sdk use java 17.0.12-oracle
export JAVA_HOME=~/.sdkman/candidates/java/17.0.12-oracle

# Activer Python venv  
source .venv/bin/activate

# Lancer les tests
cd 1-single-cycle
make test
