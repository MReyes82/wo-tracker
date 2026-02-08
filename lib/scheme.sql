PRAGMA foreign_keys = ON;

-- Basic catalogs for exercises types, equipment types, and muscle groups
CREATE TABLE IF NOT EXISTS exercise_type (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS equipment_type (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS muscle_group (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
);
-- Catalog of available (registered) exercises added by the user
CREATE TABLE IF NOT EXISTS exercise (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  exercise_type_id INTEGER NOT NULL,
  equipment_type_id INTEGER NOT NULL,
  muscle_group_id INTEGER NOT NULL,
  default_working_weight REAL,
  is_using_metric INTEGER NOT NULL DEFAULT 1, -- 0/1
  created_at TEXT,
  updated_at TEXT,
  FOREIGN KEY (exercise_type_id) REFERENCES exercise_type(id),
  FOREIGN KEY (equipment_type_id) REFERENCES equipment_type(id),
  FOREIGN KEY (muscle_group_id) REFERENCES muscle_group(id)
);

-- Catalog of workout types, available to be used
CREATE TABLE IF NOT EXISTS workout_type (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
);

-- WORKOUT TEMPLATES (what the users plan to do, added on the app)
CREATE TABLE IF NOT EXISTS workout_template (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  type_id INTEGER NOT NULL, -- reference to workout_type
  created_at TEXT,
  updated_at TEXT,
  FOREIGN KEY (type_id) REFERENCES workout_type(id)
);
-- Table to keep track of what was planned
-- on the workout template
CREATE TABLE IF NOT EXISTS template_exercise (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  template_id INTEGER NOT NULL,
  exercise_id INTEGER NOT NULL,           -- reference to the exercise catalog
  position INTEGER DEFAULT 0,
  planned_sets INTEGER DEFAULT 0,
  FOREIGN KEY (template_id) REFERENCES workout_template(id) ON DELETE CASCADE,
  FOREIGN KEY (exercise_id) REFERENCES exercise(id)
);

-- Table to keep track of the actual workout sessions performed by the user
CREATE TABLE IF NOT EXISTS workout_session (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  template_id INTEGER,
  title TEXT,
  start_time TEXT NOT NULL,
  mesocycle_id INTEGER,        --  reference to mesocycle (optional by business logic)
  end_time TEXT,
  notes TEXT,
  created_at TEXT,
  FOREIGN KEY (template_id) REFERENCES workout_template(id) ON DELETE SET NULL
  FOREIGN KEY (mesocycle_id) REFERENCES mesocycle(id)
);

-- SNAPSHOT TABLE: exercise within a workout session, based on the template
-- Keeps planned details and links to actual performed sets
CREATE TABLE IF NOT EXISTS workout_exercise (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  template_exercise_id INTEGER,  -- opcional: origen dentro del template
  exercise_id INTEGER,           -- FK al catálogo (opcional)
  exercise_name TEXT NOT NULL,   -- snapshot
  exercise_description TEXT,
  planned_sets INTEGER,
  position INTEGER,
  notes TEXT,
  FOREIGN KEY (session_id) REFERENCES workout_session(id) ON DELETE CASCADE,
  FOREIGN KEY (template_exercise_id) REFERENCES template_exercise(id) ON DELETE SET NULL,
  FOREIGN KEY (exercise_id) REFERENCES exercise(id)
);

-- Table to keep track of each of the sets performed within a workout exercise
CREATE TABLE IF NOT EXISTS workout_set (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  workout_exercise_id INTEGER NOT NULL,
  set_number INTEGER NOT NULL,
  reps INTEGER,                  -- NULL if not registered
  weight REAL,                   -- NULL if not registered
  effort_level INTEGER,          -- RPE or RIR, NULL permisible
  effort_level_specifier CHAR, -- Specifier for the effort level closeness to the actual number (example, using RIR ~1 (close to one) or <1 (less than one))
  completed INTEGER DEFAULT 0,   -- 0/1
  completed_at TEXT,
  notes TEXT,
  FOREIGN KEY (workout_exercise_id) REFERENCES workout_exercise(id) ON DELETE CASCADE,
  UNIQUE (workout_exercise_id, set_number)
);

-- Table of mesocyles for periodization planning
CREATE TABLE IF NOT EXISTS mesocycle (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    created_at TEXT,
    updated_at TEXT,
    WEEKS_QUANTITY INTEGER NOT NULL DEFAULT 0,
    SESSIONS_PER_WEEK INTEGER NOT NULL DEFAULT 0
);