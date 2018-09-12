-- design information places here: http://dbdesigner.net/designer/schema/150395

CREATE TABLE IF NOT EXISTS Users (
	ID 						integer PRIMARY KEY AUTOINCREMENT,
	LOGIN 					text NOT NULL UNIQUE,
	PASSWORD_HASH 	text,
	PASSWORD_SALT 	text,
	EMAIL 					text,
	CREATION_DATE 	text NOT NULL,
	MODIFY_DATE 		text NOT NULL,
	IS_HIDDEN			integer NOT NULL DEFAULT 0,
	IS_DELETED			integer NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Barcodes (
	ID 			integer PRIMARY KEY AUTOINCREMENT,
	BARCODE 	text UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Gardeners (
	ID 									integer PRIMARY KEY AUTOINCREMENT,
	USER_ID 							integer NOT NULL,
	FIRST_NAME 					text,
	MIDDLE_NAME 					text,
	LAST_NAME 						text,
	FULL_NAME 						text,
	GARDENER_DESCRIPTION 	text,
	CREATION_DATE 				text NOT NULL,
	MODIFY_DATE 					text NOT NULL,
	BARCODE 							text NOT NULL,
	IS_HIDDEN						integer NOT NULL DEFAULT 0,
	IS_DELETED						integer NOT NULL DEFAULT 0,
	FOREIGN KEY (USER_ID) REFERENCES Users ( ID ) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (BARCODE) REFERENCES Barcodes (BARCODE) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Object_types (
	ID							integer PRIMARY KEY AUTOINCREMENT,
	TYPE_NAME 				text NOT NULL UNIQUE,
	TYPE_DESCRIPTION text,
	IS_HIDDEN				integer NOT NULL DEFAULT 0,
	IS_DELETED				integer NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Culture_types (
	ID 											integer PRIMARY KEY AUTOINCREMENT,
	CULTURE_TYPE 						text UNIQUE NOT NULL,
	CULTURE_TYPE_DESCRIPTION	text,
	OBJECT_TYPE_ID						integer NOT NULL,
	OBJECT_TYPE_NAME					text,
	IS_HIDDEN								integer NOT NULL DEFAULT 0,
	IS_DELETED								integer NOT NULL DEFAULT 0,
	FOREIGN KEY (OBJECT_TYPE_ID) REFERENCES Object_types (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (OBJECT_TYPE_NAME) REFERENCES Object_types (TYPE_NAME) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Cultivars (
	ID									integer PRIMARY KEY AUTOINCREMENT,
	CULTURE_ID						integer,
	CULTURE_TYPE					text NOT NULL,
	CULTIVAR_NAME				text NOT NULL,
	CULTIVAR_DESCRIPTION	text,
	IS_HIDDEN						integer NOT NULL DEFAULT 0,
	IS_DELETED						integer NOT NULL DEFAULT 0,
	FOREIGN KEY (CULTURE_ID) REFERENCES Cultures (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (CULTURE_TYPE) REFERENCES Cultures (CULTURE_TYPE) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Meteo_stations (
	ID							integer PRIMARY KEY AUTOINCREMENT,
	STATION_NAME			text NOT NULL,
	ENITUDE_COORD		integer NOT NULL,
	LONGTITUDE_COORD	integer NOT NULL,
	COUNTRY					text,
	HEIGHT						integer,
	IS_HIDDEN				integer NOT NULL DEFAULT 0,
	IS_DELETED				integer NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Parcels (
	ID													integer PRIMARY KEY AUTOINCREMENT,
	PARCEL_NAME									text NOT NULL UNIQUE,
	PARCEL_DESCRIPTION						text,
	ENITUDE_COORD								integer,
	LONGTITUDE_COORD							integer,
	CHART												blob,
	CADASTR_NUMBER								text,
	LOCAL_METEO_STATION_ID				integer,
	LOCAL_METEO_STATION_DISTANCE	integer,
	CREATION_DATE								text NOT NULL,
	MODIFY_DATE									text NOT NULL,
	BARCODE											text NOT NULL,
	TAGS_JSON										text,
	IS_HIDDEN										integer NOT NULL DEFAULT 0,
	IS_DELETED										integer NOT NULL DEFAULT 0,
	FOREIGN KEY (BARCODE) REFERENCES Barcodes (BARCODE) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (LOCAL_METEO_STATION_ID) REFERENCES Meteo_stations (ID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Gardeners_parcels (
	GARDENER_ID	integer NOT NULL,
	PARCEL_ID		integer NOT NULL,
	FOREIGN KEY (GARDENER_ID) REFERENCES Gardeners (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (PARCEL_ID) REFERENCES Parcels (ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Time_ranges (
	ID						integer PRIMARY KEY AUTOINCREMENT,
	TIME_RANGE	text NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Wind_direction (
	ID								integer PRIMARY KEY AUTOINCREMENT,
	WIND_DIRECTION			text NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Conditions_of_weather (
	ID								integer PRIMARY KEY AUTOINCREMENT,
	CONDITION_NAME			text NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Cloud_conditions (
	ID											integer PRIMARY KEY AUTOINCREMENT,
	CLOUD_CONDITION_NAME			text UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Comfort_levels (
	ID										integer PRIMARY KEY AUTOINCREMENT,
	COMFORT_LEVEL_TYPE			text NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Weather_conditions (
	ID								integer PRIMARY KEY AUTOINCREMENT,
	PARCEL_ID					integer NOT NULL,
	WEATHER_DATE				text NOT NULL,
	WEATHER_TIMERANGE	integer,
	WEATHER_TYPE				text NOT NULL,
	WEATHER_JSON				text,
	IS_HIDDEN					integer NOT NULL DEFAULT 0,
	IS_DELETED					integer NOT NULL DEFAULT 0,
	FOREIGN KEY (PARCEL_ID) REFERENCES Parcels (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (WEATHER_TIMERANGE) REFERENCES Time_ranges (ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Objects(
	ID										integer PRIMARY KEY AUTOINCREMENT,
	TYPE_ID								integer NOT NULL,
	CULTURE_ID							integer,
	CULTIVAR_ID						integer,
	TYPE_NAME							text NOT NULL,
	CULTURE_NAME						text,
	CULTIVAR_NAME					text,
	OBJECT_NAME						text NOT NULL,
	OBJECT_DESCRIPTION			text,
	PARCEL_ID							integer NOT NULL,
	TOP_LEFT_COORDINATE_X	integer NOT NULL,
	TOP_LEFT_COORDINATE_Y	integer NOT NULL,
	LENGTH_X								integer NOT NULL,
	WIDTH_Y								integer NOT NULL,
	PLANTED_YEAR						text NOT NULL,
	PLANTED_BY_ID					integer,
	DISPOSAL_YEAR					text,
	DISPOSED_BY_ID					integer,
	CREATION_DATE					text NOT NULL,
	MODIFY_DATE						text NOT NULL,
	BARCODE								text NOT NULL,
	TAGS_JSON							text,
	IS_HIDDEN							integer NOT NULL DEFAULT 0,
	IS_DELETED							integer NOT NULL DEFAULT 0,
	FOREIGN KEY (TYPE_ID) REFERENCES Object_types (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (TYPE_NAME) REFERENCES Object_types (TYPE_NAME) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (CULTURE_ID) REFERENCES Culture_types (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (CULTURE_NAME) REFERENCES Culture_types (CULTURE_TYPE) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (CULTIVAR_ID) REFERENCES Cultuivars (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (CULTIVAR_NAME) REFERENCES Cultuivars (CULTIVAR_NAME) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (PLANTED_BY_ID) REFERENCES Gardeners (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (DISPOSED_BY_ID) REFERENCES Gardeners (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (BARCODE) REFERENCES Barcodes (BARCODE) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Note_types (
	ID										integer PRIMARY KEY AUTOINCREMENT,
	NOTE_TYPE_NAME					text NOT NULL,
	NOTE_TYPE_DESCRIPTION	text
);

CREATE TABLE IF NOT EXISTS Notes (
	ID						integer PRIMARY KEY AUTOINCREMENT,
	OBJECT_ID			integer NOT NULL,
	GARDENER_ID		integer NOT NULL,
	NOTE_TYPE_ID		integer NOT NULL,
	NOTE_JSON			text NOT NULL,
	NOTE_DATE			text NOT NULL,
	CREATION_DATE	text NOT NULL,
	MODIFY_DATE		text NOT NULL,
	TAGS_JSON			text,
	FOREIGN KEY (OBJECT_ID) REFERENCES Objects (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (GARDENER_ID) REFERENCES Gardeners (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (NOTE_TYPE_ID) REFERENCES Note_types (ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Measure_types (
	ID									integer PRIMARY KEY AUTOINCREMENT,
	MEASURE_TYPE					text NOT NULL UNIQUE,
	MEASURE_DESCRIPTION	text
);

CREATE TABLE IF NOT EXISTS Treat_type (
	ID										integer PRIMARY KEY AUTOINCREMENT,
	TREAT_TYPE							text NOT NULL UNIQUE,
	TREAT_TYPE_DESCRIPTION	text
);

-- Set time ranges constants
INSERT INTO Time_ranges (TIME_RANGE) VALUES (	'{"12H": "12 - 03 am", "24H": "00 - 03"}');
INSERT INTO Time_ranges (TIME_RANGE) VALUES (	'{"12H": "03 - 06 am", "24H": "03 - 06"}');
INSERT INTO Time_ranges (TIME_RANGE) VALUES (	'{"12H": "06 - 09 am", "24H": "06 - 09"}');
INSERT INTO Time_ranges (TIME_RANGE) VALUES (	'{"12H": "09 am - 12 pm", "24H": "09 - 12"}');
INSERT INTO Time_ranges (TIME_RANGE) VALUES (	'{"12H": "12 - 03 pm", "24H": "12 - 15"}');
INSERT INTO Time_ranges (TIME_RANGE) VALUES (	'{"12H": "03 - 06 pm", "24H": "15 - 18"}');
INSERT INTO Time_ranges (TIME_RANGE) VALUES (	'{"12H": "06 - 09 pm", "24H": "18 - 21"}');
INSERT INTO Time_ranges (TIME_RANGE) VALUES (	'{"12H": "09 pm - 12 am", "24H": "21 - 24"}');

-- Set conditions of weather
INSERT INTO Conditions_of_weather (CONDITION_NAME) VALUES ('{"EN": "Fog", "RU": "Туман"}');

--Set wind directions
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "Nord", "RU": "Северный"}');
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "NordWest", "RU": "Северо-западный"}');
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "West", "RU": "Западный"}');
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "SouthWest", "RU": "Юго-западный"}');
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "South", "RU": "Южный"}');
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "SouthEast", "RU": "Юго-восточный"}');
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "East", "RU": "Восточный"}');
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "NordEast", "RU": "Северо-восточный"}');
INSERT INTO Wind_direction (WIND_DIRECTION) VALUES ('{"EN": "Silence", "RU": "Штиль"}');

-- Set cloud conditions
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Ясно", "EN": "Clear",  "CODE": "None", "TYPE_EN": "Clear sky", "TYPE_RU": "Чистое небо"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перистые", "EN": "Cirrus",  "CODE": "Ci", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перистые волокнистые", "EN": "Cirrus fibratus",  "COD": "Ci fib", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перистые плотные", "EN": "Cirrus spissatus",  "CODE": "Ci sp", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перисто-кучевые", "EN": "Cirrocumulus",  "CODE": "Сс", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перисто-кучевые волнистообразные", "EN": "Cirrocumulus undulatus",  "CODE": "Сс und", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перисто-кучевые кучевообразные", "EN": "Cirrocumulus cumuliformis",  "CODE": "Сс cuf", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перисто-слоистые", "EN": "Cirrostratus",  "CODE": "Cs", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перисто-слоистые волокнистые", "EN": "Cirrostratus fibratus",  "CODE": "Cs fib", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Перисто-слоистые туманообразные", "EN": "Cirrostratus nebulosus",  "CODE": "Cs neb", "TYPE_EN": "High-level clouds", "TYPE_RU": "Облака верхнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Высококучевые", "EN": "Altocumulus",  "CODE": "Ac", "TYPE_EN": "Mid-level clouds", "TYPE_RU": "Облака среднего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Высококучевые волнистообразные", "EN": "Altocumulus undulatus",  "CODE": "Ac und", "TYPE_EN": "Mid-level clouds", "TYPE_RU": "Облака среднего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Высококучевые кучевообразные", "EN": "Altocumulus cumuliformis",  "CODE": "Ac cuf", "TYPE_EN": "Mid-level clouds", "TYPE_RU": "Облака среднего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Высокослоистые", "EN": "Altostratus",  "CODE": "As", "TYPE_EN": "Mid-level clouds", "TYPE_RU": "Облака среднего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Высокослоистые туманообразные", "EN": "Altostratus nebulosus",  "CODE": "As neb", "TYPE_EN": "Mid-level clouds", "TYPE_RU": "Облака среднего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Высокослоистые волнистообразные", "EN": "Altostratus undulatus",  "CODE": "As und", "TYPE_EN": "Mid-level clouds", "TYPE_RU": "Облака среднего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Слоисто-кучевые", "EN": "Stratocumulus",  "CODE": "Sc", "TYPE_EN": "Low-level clouds", "TYPE_RU": "Облака нижнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Слоисто-кучевые волнистообразные", "EN": "Stratocumulus undulatus",  "CODE": "Sc und", "TYPE_EN": "Low-level clouds", "TYPE_RU": "Облака нижнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Слоисто-кучевые кучевообразные", "EN": "Stratocumulus cumuliformis",  "CODE": "Sc cuf", "TYPE_EN": "Low-level clouds", "TYPE_RU": "Облака нижнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Слоистые", "EN": "Stratus",  "CODE": "St", "TYPE_EN": "Low-level clouds", "TYPE_RU": "Облака нижнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Слоистые туманообразные", "EN": "Stratus nebulosus",  "CODE": "St neb", "TYPE_EN": "Low-level clouds", "TYPE_RU": "Облака нижнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Слоистые волнистообразные", "EN": "Stratus undulatus",  "CODE": "St und", "TYPE_EN": "Low-level clouds", "TYPE_RU": "Облака нижнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Разорванно-слоистые", "EN": "Stratus fractus",  "CODE": "St fr", "TYPE_EN": "Low-level clouds", "TYPE_RU": "Облака нижнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Слоисто-дождевые", "EN": "Nimbostratus",  "CODE": "Ns", "TYPE_EN": "Multi-level/vertical", "TYPE_RU": "Облака нижнего яруса"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Кучевые", "EN": "Cumulus",  "CODE": "Сu", "TYPE_EN": "Towering vertical", "TYPE_RU": "Облака вертикального развития"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Кучевые плоские", "EN": "Cumulus humilis",  "CODE": "Сu hum", "TYPE_EN": "Low-level clouds", "TYPE_RU": "Облака вертикального развития"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Кучевые средние", "EN": "Cumulus mediocris",  "CODE": "Сu med", "TYPE_EN": "Multi-level/vertical", "TYPE_RU": "Облака вертикального развития"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Кучевые мощные", "EN": "Cumulus congestus",  "CODE": "Сu cong", "TYPE_EN": "Towering vertical", "TYPE_RU": "Облака вертикального развития"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Кучево-дождевые", "EN": "Cumulonimbus",  "CODE": "Cb", "TYPE_EN": "Towering vertical", "TYPE_RU": "Облака вертикального развития"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Кучево-дождевые лысые", "EN": "Cumulonimbus calvus",  "CODE": "Cb calv", "TYPE_EN": "Towering vertical", "TYPE_RU": "Облака вертикального развития"}');
INSERT INTO Cloud_conditions (CLOUD_CONDITION_NAME) VALUES ('{"RU": "Кучево-дождевые волосатые", "EN": "Cumulonimbus capillatus",  "CODE": "Cb cap", "TYPE_EN": "Towering vertical", "TYPE_RU": "Облака вертикального развития"}');



-- Set comfort level names
INSERT INTO Comfort_levels (COMFORT_LEVEL_TYPE) VALUES ('{"EN": "Cold", "RU": "Холодно"}');
INSERT INTO Comfort_levels (COMFORT_LEVEL_TYPE) VALUES ('{"EN": "Very cold", "RU": "Очень холодно"}');
INSERT INTO Comfort_levels (COMFORT_LEVEL_TYPE) VALUES ('{"EN": "Cool", "RU": "Прохладно"}');
INSERT INTO Comfort_levels (COMFORT_LEVEL_TYPE) VALUES ('{"EN": "By season", "RU": "По сезону"}');
INSERT INTO Comfort_levels (COMFORT_LEVEL_TYPE) VALUES ('{"EN": "Warm", "RU": "Тепло"}');
INSERT INTO Comfort_levels (COMFORT_LEVEL_TYPE) VALUES ('{"EN": "Comfortable", "RU": "Комфорт"}');
INSERT INTO Comfort_levels (COMFORT_LEVEL_TYPE) VALUES ('{"EN": "Hot", "RU": "Жарко"}');
INSERT INTO Comfort_levels (COMFORT_LEVEL_TYPE) VALUES ('{"EN": "Very hot", "RU": "Очень жарко"}');

insert into Note_types (NOTE_TYPE_NAME, NOTE_TYPE_DESCRIPTION) values ('{"EN": "Text note", "RU": "Текстовая заметка"}', '{"EN": "Note with simple text", "RU": "Заметка из простого текста"}');
insert into Note_types (NOTE_TYPE_NAME, NOTE_TYPE_DESCRIPTION) values ('{"EN": "Weather note", "RU": "Заметка о погоде"}', '{"EN": "Note with weather characteristics", "RU": "Заметка со списком погодных характеристик"}');
insert into Note_types (NOTE_TYPE_NAME, NOTE_TYPE_DESCRIPTION) values ('{"EN": "URL-link note", "RU": "URL-ссылка"}', '{"EN": "Note with just URL-link", "RU": "Заметка с URL-ссылкой"}');
insert into Note_types (NOTE_TYPE_NAME, NOTE_TYPE_DESCRIPTION) values ('{"EN": "Photo note", "RU": "Заметка с фотографиями"}', '{"EN": "Note with some photos", "RU": "Заметка с несколькими фотографиями"}');
insert into Note_types (NOTE_TYPE_NAME, NOTE_TYPE_DESCRIPTION) values ('{"EN": "Video note", "RU": "Видеозаметка"}', '{"EN": "Note with video", "RU": "Заметка с видеозаписью"}');
insert into Note_types (NOTE_TYPE_NAME, NOTE_TYPE_DESCRIPTION) values ('{"EN": "Treatment note", "RU": "Заметка об уходе"}', '{"EN": "Note with treatment description", "RU": "Заметка, содержащяя информацию об уходе за растением"}');
insert into Note_types (NOTE_TYPE_NAME, NOTE_TYPE_DESCRIPTION) values ('{"EN": "Harvesting note", "RU": "Заметка о сборе урожая"}', '{"EN": "Note with information about harvest", "RU": "Заметка, содержащяя информацию о сборе урожая"}');

--CREATE TABLE Note_photo (
--	ID integer,
--	PHOTO_LINK text,
--	PHOTO_DESCRIPTION text,
--	PHOTO_EXIF_DATA text
--);

--CREATE TABLE Note_text (
--	ID integer,
--	NOTE_TEXT text
--);

--CREATE TABLE Note_video (
--	ID integer,
--	VIDEO_LINK text,
--	VIDEO_DESCRIPTION text,
--	VIDEO_METADATA text
--);

--CREATE TABLE Note_link (
--	ID integer,
--	HYPERLINK text,
--	HYPERLINK_DESCRIPTION text
--);

--CREATE TABLE Note_measurement (
--	ID integer,
--	MEASURE_TYPE_ID integer,
--	MEASURE_STATEMENT integer
--);

--CREATE TABLE Note_treatment (
--	ID integer,
--	TREAT_TYPE_ID integer,
--	TREAT_DESCRIPTION text
--);

--CREATE TABLE Weather_conditions_format (
--	date datetime,
--	timerange text,
--	wind_direction text,
--	wind_strength integer,
--	visibility_range integer,
--	conditions text,
--	cloudness text,
--	air_temperature integer,
--	dew_temperature integer,
--	humidity integer,
--	effective_temp integer,
--	effective_sun_temp integer,
--	comfort_level text,
--	atm_pressure_sea integer,
--	atm_pressure integer,
--	temperature_minimum integer,
--	temperature_maximum integer,
--	rainfall integer,
--	snowfall integer,
--	meteostation_id integer
--);