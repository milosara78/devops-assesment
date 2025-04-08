package db

import (
	"database/sql"
	"fmt"
	"log"
	"net/url"
	"os"
	"simplebank/pkg/config"
	"testing"

	_ "github.com/lib/pq" // PostgreSQL driver
	"github.com/pressly/goose"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	var err error
	config.LoadConfigs("../../../config/default.yaml")
	cfg := config.GetConfigs()
	
	testDB, err = sql.Open("postgres", dbstring)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v\n", err)
	}

	if cfg.Postgres.Automigrate {
		// Run Goose migrations
		err = goose.Up(testDB, "../../../db/migrations")
		if err != nil {
			log.Fatalf("Failed to run migrations: %v\n", err)
		}
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
