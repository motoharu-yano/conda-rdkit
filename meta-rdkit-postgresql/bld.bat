xcopy "%RECIPE_DIR%/install_pgsql_gzip_postgresql.sh" "%SRC_DIR%/install_pgsql_gzip_postgresql.sh"
xcopy "%RECIPE_DIR%/install_rdkit_postgresql.sh" "%SRC_DIR%/install_rdkit_postgresql.sh"

.\install_pgsql_gzip_postgresql.bat

.\install_rdkit_postgresql.bat
