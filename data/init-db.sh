#!/bin/bash

# Seed script for Postgres which is only ran if Postgres does not have data.

set -e

INIT_DIR=/docker-entrypoint-initdb.d/

psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f ${INIT_DIR}/tables.sql
