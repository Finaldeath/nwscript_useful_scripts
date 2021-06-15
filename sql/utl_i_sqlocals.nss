//::///////////////////////////////////////////////
//:: Utility Include: SQLocals
//:: utl_i_sqlocals.nss
//:://////////////////////////////////////////////
/*
    Daz wrote these library functions to act as replacements for the usual local
    functions:
    * GetLocalInt / SetLocalInt / DeleteLocalInt
    * GetLocalFloat / SetLocalFloat / DeleteLocalFloat
    * GetLocalString / SetLocalString / DeleteLocalString
    * GetLocalObject / SetLocalObject / DeleteLocalObject (NB: remember these are references NOT serialised objects)
    * GetLocalLocation / SetLocalLocation / DeleteLocalLocation
    * Plus a new function for saving just a vector by itself.


    Since sometimes iterating over many locals is slow, this might be an excellent way to
    speed up large amounts of access, or for debugging, or using regex or whatever else.

    The oObject field is used as a reference - all of these are set on the modules sqlite DB. 

    The module sqlite DB is saved to the save game so is persistent within a singleplayer (or co-op) module
    runthrough but not retained on restarting a PW server.
    
    See utl_i_sqlplayer.nss for the player persistent version (which does travel between modules).
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Constant name changed to DB since it will be a primary differentiator for the end-user and
//  is extremely easy to use/spell/include, allowing the user to immediately know if they're
//  saving their data to the sqlite database or not.
const string DB                      = "sqlocals_table";
//const string SQLOCALS_TABLE_NAME     = "sqlocals_table";

const int SQLOCALS_TYPE_ALL          = 0;
const int SQLOCALS_TYPE_INT          = 1;
const int SQLOCALS_TYPE_FLOAT        = 2;
const int SQLOCALS_TYPE_STRING       = 4;
const int SQLOCALS_TYPE_OBJECT       = 8;
const int SQLOCALS_TYPE_VECTOR       = 16;
const int SQLOCALS_TYPE_LOCATION     = 32;

// Returns an integer stored on oObject, or 0 on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
int SQLocals_GetInt(object oObject, string sVarName);
// Sets an integer stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * nValue - Value to store
void SQLocals_SetInt(object oObject, string sVarName, int nValue);
// Deletes an integer stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteInt(object oObject, string sVarName);

// Returns a float stored on oObject, or 0.0 on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
float SQLocals_GetFloat(object oObject, string sVarName);
// Sets a float stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * fValue - Value to store
void SQLocals_SetFloat(object oObject, string sVarName, float fValue);
// Deletes a float stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteFloat(object oObject, string sVarName);

// Returns an string stored on oObject, or "" on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
string SQLocals_GetString(object oObject, string sVarName);
// Sets a string stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * sValue - Value to store
void SQLocals_SetString(object oObject, string sVarName, string sValue);
// Deletes a string stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteString(object oObject, string sVarName);

// Returns an object identifier stored on oObject
// If this is used on a player it might return a "once valid" OID, so check
// with GetIsObjectValid, do not compare to OBJECT_INVALID.
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
object SQLocals_GetObject(object oObject, string sVarName);
// Sets an object identifier stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * oValue - Value to store
void SQLocals_SetObject(object oObject, string sVarName, object oValue);
// Deletes an object identifier stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteObject(object oObject, string sVarName);

// Returns a vector stored on oObject, or [0.0, 0.0, 0.0] on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
vector SQLocals_GetVector(object oObject, string sVarName);
// Sets a vector stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * vValue - Value to store
void SQLocals_SetVector(object oObject, string sVarName, vector vValue);
// Deletes a vector stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteVector(object oObject, string sVarName);

// Returns a location stored on oObject, or the starting location of the module on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
location SQLocals_GetLocation(object oObject, string sVarName);
// Sets a location stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * lValue - Value to store
void SQLocals_SetLocation(object oObject, string sVarName, location lValue);
// Deletes a location stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteLocation(object oObject, string sVarName);

// Deletes a set of locals stored on oObject matching the given criteria
// * oObject - an object to reference against
// * nType - The SQLOCALS_TYPE_* you wish to remove (default: SQLOCALS_TYPE_ALL)
// * sLike - The string to compare with the SQL "like" comparison
// * sEscape - The escape character to use with the SQL "escape" keyword
void SQLocals_Delete(object oObject, int nType = SQLOCALS_TYPE_ALL, string sLike = "", string sEscape = "");
// Counts a set of locals stored on oObject matching the given criteria
// * oObject - an object to reference against
// * nType - The SQLOCALS_TYPE_* you wish to count (default: SQLOCALS_TYPE_ALL)
// * sLike - The string to compare with the SQL "like" comparison
// * sEscape - The escape character to use with the SQL "escape" keyword
int SQLocals_Count(object oObject, int nType = SQLOCALS_TYPE_ALL, string sLike = "", string sEscape = "");
// Checks a locals stored on oObject is set
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALS_TYPE_* you wish to check
int SQLocals_IsSet(object oObject, string sVarName, int nType);
// Returns the last Unix time the given variable was updated
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALS_TYPE_* you wish to check
int SQLocals_GetLastUpdated_UnixEpoch(object oObject, string sVarName, int nType);
// Returns the last UTC time the given variable was updated
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALS_TYPE_* you wish to check
string SQLocals_GetLastUpdated_UTC(object oObject, string sVarName, int nType);


/* INTERNAL */
void SQLocals_CreateTable(string sTable = DB)
{
    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "CREATE TABLE IF NOT EXISTS " + sTable + " (" +
        "object TEXT, " +
        "type INTEGER, " +
        "varname TEXT, " +
        "value TEXT, " +
        "timestamp INTEGER, " +
        "PRIMARY KEY(object, type, varname));");
    SqlStep(sql);
}

sqlquery SQLocals_PrepareSelect(object oObject, int nType, string sVarName, string sTable = DB)
{
    SQLocals_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "SELECT value FROM " + sTable + " " +
        "WHERE object = @object AND type = @type AND varname = @varname;");

    SqlBindString(sql, "@object", ObjectToString(oObject));
    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    return sql;
}

sqlquery SQLocals_PrepareInsert(object oObject, int nType, string sVarName, sTable = DB)
{
    SQLocals_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "INSERT INTO " + sTable + " " +
        "(object, type, varname, value, timestamp) VALUES (@object, @type, @varname, @value, strftime('%s','now')) " +
        "ON CONFLICT (object, type, varname) DO UPDATE SET value = @value, timestamp = strftime('%s','now');");

    SqlBindString(sql, "@object", ObjectToString(oObject));
    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    return sql;
}

sqlquery SQLocals_PrepareDelete(object oObject, int nType, string sVarName, sTable = DB)
{
    SQLocals_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "DELETE FROM " + sTable + " " +
        "WHERE object = @object AND type = @type AND varname = @varname;");

    SqlBindString(sql, "@object", ObjectToString(oObject));
    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    return sql;
}

string SQLocals_LocationToString(location locLocation)
{
    string sAreaId = ObjectToString(GetAreaFromLocation(locLocation));
    vector vPosition = GetPositionFromLocation(locLocation);
    float fFacing = GetFacingFromLocation(locLocation);

    return "#A#" + sAreaId +
           "#X#" + FloatToString(vPosition.x, 0, 5) +
           "#Y#" + FloatToString(vPosition.y, 0, 5) +
           "#Z#" + FloatToString(vPosition.z, 0, 5) +
           "#F#" + FloatToString(fFacing, 0, 5) + "#";
}

location SQLocals_StringToLocation(string sLocation)
{
    location locLocation;

    int nLength = GetStringLength(sLocation);

    if(nLength > 0)
    {
        int nPos, nCount;

        nPos = FindSubString(sLocation, "#A#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        object oArea = StringToObject(GetSubString(sLocation, nPos, nCount));

        nPos = FindSubString(sLocation, "#X#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        float fX = StringToFloat(GetSubString(sLocation, nPos, nCount));

        nPos = FindSubString(sLocation, "#Y#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        float fY = StringToFloat(GetSubString(sLocation, nPos, nCount));

        nPos = FindSubString(sLocation, "#Z#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        float fZ = StringToFloat(GetSubString(sLocation, nPos, nCount));

        vector vPosition = Vector(fX, fY, fZ);

        nPos = FindSubString(sLocation, "#F#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        float fOrientation = StringToFloat(GetSubString(sLocation, nPos, nCount));

        if (GetIsObjectValid(oArea))
            locLocation = Location(oArea, vPosition, fOrientation);
        else
            locLocation = GetStartingLocation();
    }

    return locLocation;
}
/* **** */

// New function to ensure we're putting variables in the correct place based on the user's desires.
object GetTarget(object oObject, string sTable)
{
    object module = GetModule();

    // OBJECT_INVALID or asking for the module, just send it back.  This also allows the user to
    //  pass OBJECT_INVALID for a direct module put instead of calling GetModule() and then calling
    //  it again here.  Not much efficiency, but something.
    if (oObject == OBJECT_INVALID || oObject == module)
        return module;

    // For PC objects
    if (GetIsPC(oObject))
    {
        if (sTable == "")
        {
            // sTable == "" means we want to save on the PC object or their datapoint, not the DB
            object oData = GetItemPossessedBy(oObject, PLAYER_DATAPOINT);
            if (GetIsObjectValid(oData))
                // We're using a player datapoint system, return the datapoint
                return oData;
            else
                // We're not using a player datapoint system, so just return the PC object
                return oObject;
        }
        else
            // sTable != "" means we want to save on the PC database, so we need the PC object
            return oObject;
    }
    else if (sTable == "")
    {
        // Not a PC and sTable == "" means we want to save a variable on an object, so send back the object
        return oObject;
    }
    else
        // Not a PC and sTable != "" means we want to save to the central database, which is on the module
        return module;

    // Failsafe
    return oObject;
}

// Change name to _GetLocalInt to make it more obvious what it was for and make it more accessible
// sTable is a new optional parameter.  If not passed, this function works exactly like bioware's
// GetLocalInt function and gets the variable directly from the passed object.  If the standard tablename
// (DB) is passed, it saves to the default table.  If a custom table name is passed, it uses that table
//  on the passed object.  This makes the calls simple for the user to know what's going on:

// _GetLocalInt(oTarget, sVarName) gets sVarName directly off oTarget
// _GetLocalInt(oTarget, sVarName, DB) gets sVarName from the sqlite database assigned to the PC (if
//          oTarget is a PC) or the Module's sqlite database, from table "sqlocals_table".
// _GetLocalInt(oTarget, sVarName, "myTable") gets sVarName from the sqlite database assigned to the PC
//          (if oTarget is a PC) or the Module's sqlite database, from the table "myTable".
int _GetLocalInt(object oTarget, string sVarName, string sTable = "")
{
    // Since we're combining, we have to make sure we're sending data to the right place.
    //  FindTarget is a new addition, see above.
    oTarget = FindTarget(oTarget);

    if (sTable == "")
        // We're just saving a variable to whatever was returned ... this is the way.
        return GetLocalInt(oTarget, sVarName);

    // sTable != "", so we want to save to the default or a specific table
    sqlquery sql = SQLocals_PrepareSelect(oObject, SQLOCALS_TYPE_INT, sVarName, sTable);

    // No changes from here down
    if (SqlStep(sql))
        return SqlGetInt(sql, 0);
    else
        return 0;
}

/* INT */
// Returns an integer stored on oObject, or 0 on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
int SQLocals_GetInt(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "")
        return 0;

    sqlquery sql = SQLocals_PrepareSelect(oObject, SQLOCALS_TYPE_INT, sVarName);

    if (SqlStep(sql))
        return SqlGetInt(sql, 0);
    else
        return 0;
}


// Sets an integer stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * nValue - Value to store
void SQLocals_SetInt(object oObject, string sVarName, int nValue)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareInsert(oObject, SQLOCALS_TYPE_INT, sVarName);
    SqlBindInt(sql, "@value", nValue);
    SqlStep(sql);
}

// Deletes an integer stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteInt(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareDelete(oObject, SQLOCALS_TYPE_INT, sVarName);
    SqlStep(sql);
}
/* **** */

/* FLOAT */

// Returns a float stored on oObject, or 0.0 on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
float SQLocals_GetFloat(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return 0.0f;

    sqlquery sql = SQLocals_PrepareSelect(oObject, SQLOCALS_TYPE_FLOAT, sVarName);

    if (SqlStep(sql))
        return SqlGetFloat(sql, 0);
    else
        return 0.0f;
}

// Sets a float stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * fValue - Value to store
void SQLocals_SetFloat(object oObject, string sVarName, float fValue)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareInsert(oObject, SQLOCALS_TYPE_FLOAT, sVarName);
    SqlBindFloat(sql, "@value", fValue);
    SqlStep(sql);
}

// Deletes a float stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteFloat(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareDelete(oObject, SQLOCALS_TYPE_FLOAT, sVarName);
    SqlStep(sql);
}
/* **** */

/* STRING */

// Returns an string stored on oObject, or "" on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
string SQLocals_GetString(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return "";

    sqlquery sql = SQLocals_PrepareSelect(oObject, SQLOCALS_TYPE_STRING, sVarName);

    if (SqlStep(sql))
        return SqlGetString(sql, 0);
    else
        return "";
}

// Sets a string stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * sValue - Value to store
void SQLocals_SetString(object oObject, string sVarName, string sValue)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareInsert(oObject, SQLOCALS_TYPE_STRING, sVarName);
    SqlBindString(sql, "@value", sValue);
    SqlStep(sql);
}

// Deletes a string stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteString(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareDelete(oObject, SQLOCALS_TYPE_STRING, sVarName);
    SqlStep(sql);
}
/* **** */

/* OBJECT */


// Returns an object identifier stored on oObject
// If this is used on a player it might return a "once valid" OID, so check
// with GetIsObjectValid, do not compare to OBJECT_INVALID.
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
object SQLocals_GetObject(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return OBJECT_INVALID;

    sqlquery sql = SQLocals_PrepareSelect(oObject, SQLOCALS_TYPE_OBJECT, sVarName);

    if (SqlStep(sql))
        return StringToObject(SqlGetString(sql, 0));
    else
        return OBJECT_INVALID;
}

// Sets an object identifier stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * oValue - Value to store
void SQLocals_SetObject(object oObject, string sVarName, object oValue)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareInsert(oObject, SQLOCALS_TYPE_OBJECT, sVarName);
    SqlBindString(sql, "@value", ObjectToString(oValue));
    SqlStep(sql);
}

// Deletes an object identifier stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteObject(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareDelete(oObject, SQLOCALS_TYPE_OBJECT, sVarName);
    SqlStep(sql);
}
/* **** */

/* VECTOR */

// Returns a vector stored on oObject, or [0.0, 0.0, 0.0] on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
vector SQLocals_GetVector(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return [0.0f, 0.0f, 0.0f];

    sqlquery sql = SQLocals_PrepareSelect(oObject, SQLOCALS_TYPE_VECTOR, sVarName);

    if (SqlStep(sql))
        return SqlGetVector(sql, 0);
    else
        return [0.0f, 0.0f, 0.0f];
}

// Sets a vector stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * vValue - Value to store
void SQLocals_SetVector(object oObject, string sVarName, vector vValue)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareInsert(oObject, SQLOCALS_TYPE_VECTOR, sVarName);
    SqlBindVector(sql, "@value", vValue);
    SqlStep(sql);
}

// Deletes a vector stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteVector(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareDelete(oObject, SQLOCALS_TYPE_VECTOR, sVarName);
    SqlStep(sql);
}
/* **** */

/* LOCATION */

// Returns a location stored on oObject, or the starting location of the module on error
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
location SQLocals_GetLocation(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return GetStartingLocation();

    sqlquery sql = SQLocals_PrepareSelect(oObject, SQLOCALS_TYPE_LOCATION, sVarName);

    if (SqlStep(sql))
        return SQLocals_StringToLocation(SqlGetString(sql, 0));
    else
        return GetStartingLocation();
}

// Sets a location stored on oObject to the given value
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * lValue - Value to store
void SQLocals_SetLocation(object oObject, string sVarName, location lValue)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareInsert(oObject, SQLOCALS_TYPE_LOCATION, sVarName);
    SqlBindString(sql, "@value", SQLocals_LocationToString(lValue));
    SqlStep(sql);
}

// Deletes a location stored on oObject
// * oObject - an object to reference against
// * sVarName - name of the variable to delete
void SQLocals_DeleteLocation(object oObject, string sVarName)
{
    if (oObject == OBJECT_INVALID || sVarName == "") return;

    sqlquery sql = SQLocals_PrepareDelete(oObject, SQLOCALS_TYPE_LOCATION, sVarName);
    SqlStep(sql);
}
/* **** */

/* UTILITY */

// Deletes a set of locals stored on oObject matching the given criteria
// * oObject - an object to reference against
// * nType - The SQL_LOCALS_TYPE_* you wish to remove (default: SQL_LOCALS_TYPE_ALL)
// * sLike - The string to compare with the SQL "like" comparison
// * sEscape - The escape character to use with the SQL "escape" keyword
void SQLocals_Delete(object oObject, int nType = SQLOCALS_TYPE_ALL, string sLike = "", string sEscape = "")
{
    if (oObject == OBJECT_INVALID || nType < 0) return;

    SQLocals_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "DELETE FROM " + SQLOCALS_TABLE_NAME + " " +
        "WHERE object = @object " +
        (nType != SQLOCALS_TYPE_ALL ? "AND type & @type " : " ") +
        (sLike != "" ? "AND varname LIKE @like " + (sEscape != "" ? "ESCAPE @escape" : "") : "") +
        ";");

    SqlBindString(sql, "@object", ObjectToString(oObject));

    if (nType != SQLOCALS_TYPE_ALL)
        SqlBindInt(sql, "@type", nType);
    if (sLike != "")
    {
        SqlBindString(sql, "@like", sLike);

        if (sEscape != "")
            SqlBindString(sql, "@escape", sEscape);
    }

    SqlStep(sql);
}

// Counts a set of locals stored on oObject matching the given criteria
// * oObject - an object to reference against
// * nType - The SQLOCALS_TYPE_* you wish to count (default: SQLOCALS_TYPE_ALL)
// * sLike - The string to compare with the SQL "like" comparison
// * sEscape - The escape character to use with the SQL "escape" keyword
int SQLocals_Count(object oObject, int nType = SQLOCALS_TYPE_ALL, string sLike = "", string sEscape = "")
{
    if (oObject == OBJECT_INVALID || nType < 0) return 0;

    SQLocals_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "SELECT COUNT(*) FROM " + SQLOCALS_TABLE_NAME + " " +
        "WHERE object = @object " +
        (nType != SQLOCALS_TYPE_ALL ? "AND type & @type " : " ") +
        (sLike != "" ? "AND varname LIKE @like " + (sEscape != "" ? "ESCAPE @escape" : "") : "") +
        ";");

    SqlBindString(sql, "@object", ObjectToString(oObject));

    if (nType != SQLOCALS_TYPE_ALL)
        SqlBindInt(sql, "@type", nType);
    if (sLike != "")
    {
        SqlBindString(sql, "@like", sLike);

        if (sEscape != "")
            SqlBindString(sql, "@escape", sEscape);
    }

    if (SqlStep(sql))
        return SqlGetInt(sql, 0);
    else
        return 0;
}

// Checks a locals stored on oObject is set
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALS_TYPE_* you wish to check
int SQLocals_IsSet(object oObject, string sVarName, int nType)
{
    if (oObject == OBJECT_INVALID || nType < 0) return 0;

    SQLocals_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "SELECT * FROM " + SQLOCALS_TABLE_NAME + " " +
        "WHERE object = @object " +
        (nType != SQLOCALS_TYPE_ALL ? "AND type & @type " : " ") +
        "AND varname = @varname;");

    SqlBindString(sql, "@object", ObjectToString(oObject));
    if (nType != SQLOCALS_TYPE_ALL)
        SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    return SqlStep(sql);
}

// Returns the last Unix time the given variable was updated
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALS_TYPE_* you wish to check (default: SQLOCALS_TYPE_ALL)
int SQLocals_GetLastUpdated_UnixEpoch(object oObject, string sVarName, int nType)
{
    if (oObject == OBJECT_INVALID || nType <= 0) return 0;

    SQLocals_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "SELECT timestamp FROM " + SQLOCALS_TABLE_NAME + " " +
        "WHERE object = @object " +
        "AND type = @type " +
        "AND varname = @varname;");

    SqlBindString(sql, "@object", ObjectToString(oObject));
    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    if (SqlStep(sql))
        return SqlGetInt(sql, 0);
    else
        return 0;
}

// Returns the last UTC time the given variable was updated
// * oObject - an object to reference against
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALS_TYPE_* you wish to check (default: SQLOCALS_TYPE_ALL)
string SQLocals_GetLastUpdated_UTC(object oObject, string sVarName, int nType)
{
    if (oObject == OBJECT_INVALID || nType <= 0) return "";

    SQLocals_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(GetModule(),
        "SELECT datetime(timestamp, 'unixepoch') FROM " + SQLOCALS_TABLE_NAME + " " +
        "WHERE object = @object " +
        "AND type = @type " +
        "AND varname = @varname;");

    SqlBindString(sql, "@object", ObjectToString(oObject));
    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    if (SqlStep(sql))
        return SqlGetString(sql, 0);
    else
        return "";
}