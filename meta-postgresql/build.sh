cp ${RECIPE_DIR}/install_pgsql_gzip_postgresql.sh ${SRC_DIR}/install_pgsql_gzip_postgresql.sh
cp ${RECIPE_DIR}/install_rdkit_postgresql.sh ${SRC_DIR}/install_rdkit_postgresql.sh
cp ${RECIPE_DIR}/install_citus.sh ${SRC_DIR}/install_citus.sh
cp ${RECIPE_DIR}/install_pgvector_postgresql.sh ${SRC_DIR}/install_pgvector_postgresql.sh

sh ./install_pgsql_gzip_postgresql.sh
sh ./install_rdkit_postgresql.sh
sh ./install_citus.sh
sh ./install_pgvector_postgresql.sh
