import { migrate } from "drizzle-orm/postgres-js/migrator";
import db from "./db";

export const migrateDatabase = async() => {
    console.log("Migration Started....");
    await migrate(db, {migrationsFolder: "drizzle"});
    console.log("Database Migrated");
}

migrateDatabase();