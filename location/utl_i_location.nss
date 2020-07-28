//::///////////////////////////////////////////////
//:: Utility Include: Location
//:: utl_i_location.nss
//:://////////////////////////////////////////////
/*
    This contains a number of location or position/vector based utility functions.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Get a local vector (variable prefixed VEC:)
// * oObject - Object to check for vector
// * sVarName - variable name
vector GetLocalVector(object oObject, string sVarName);

// Set a local vector (variable prefixed VEC:)
// * oObject - Object to set the vector on
// * sVarName - variable name
void SetLocalVector(object oObject, string sVarName, vector vValue);

// Set a local vector (variable prefixed VEC:)
// * oObject - Object to set the vector on
// * sVarName - variable name
void SetLocalVector(object oObject, string sVarName, vector vValue);

// Returns TRUE if the location is considered walkable.
// This doesn't necessarily mean a creature can be created there (there may be placeables in the way)
// * lLocation - Location to check
int GetIsLocationWalkable(location lLocation);

// Returns TRUE if the location is considered water
// Not all water is walkable, see surfacemat.2da for more information.
// * lLocation - Location to check
int GetIsLocationIsWater(location lLocation);

// Returns a random location in the area
// * oArea - Area to provide a random location in
location GetRandomLocation(object oArea);

// Encodes a location to a string
// Note: Uses the areas tag and resref to identify it later, not the OID.
// * lLocation - Location to encode
string EncodeLocation(location lLocation);

// Decodes a location from a string that was encoded with EncodeLocation
// * sLocation - Location string to decode
location DecodeLocation(string sLocation);



// Get a local vector (variable prefixed VEC:)
// * oObject - Object to check for vector
// * sVarName - variable name
vector GetLocalVector(object oObject, string sVarName)
{
    return GetPositionFromLocation(GetLocalLocation(oObject, "VEC:" + sVarName));
}

// Set a local vector (variable prefixed VEC:)
// * oObject - Object to set the vector on
// * sVarName - variable name
void SetLocalVector(object oObject, string sVarName, vector vValue)
{
    SetLocalLocation(oObject, "VEC:" + sVarName, Location(OBJECT_INVALID, vValue, 0.0f));
}

// Deletes a local vector (variable prefixed VEC:)
// * oObject - Object to set the vector on
// * sVarName - variable name
void DeleteLocalVector(object oObject, string sVarName)
{
    DeleteLocalLocation(oObject, "VEC:" + sVarName);
}

// Returns TRUE if the location is considered walkable.
// This doesn't necessarily mean a creature can be created there (there may be placeables in the way)
// * lLocation - Location to check
int GetIsLocationWalkable(location lLocation)
{
    // The 2da "surfacemat" contains a column to know if a location is walkable
    return StringToInt(Get2DAString("surfacemat", "Walk", GetSurfaceMaterial(lLocation)));
}

// Returns TRUE if the location is considered water
// Not all water is walkable, see surfacemat.2da for more information.
// * lLocation - Location to check
int GetIsLocationIsWater(location lLocation)
{
    // The 2da "surfacemat" contains a column to know if a location is water
    return StringToInt(Get2DAString("surfacemat", "IsWater", GetSurfaceMaterial(lLocation)));
}

// Returns a random location in the area
// * oArea - Area to provide a random location in
location GetRandomLocation(object oArea)
{
    int nX = Random(GetAreaSize(AREA_WIDTH, oArea)*100);
    int nY = Random(GetAreaSize(AREA_HEIGHT, oArea)*100);

    float fX = IntToFloat(nX)/100;
    float fY = IntToFloat(nY)/100;

    return Location(oArea, Vector(fX, fY, 0.0), 0.0);
}

// Encodes a location to a string
// Note: Uses the areas tag and resref to identify it later, not the OID.
// * lLocation - Location to encode
string EncodeLocation(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);
    float fFacing = GetFacingFromLocation(lLocation);
    string sReturnValue;

    return  "#TAG#" + GetTag(oArea) + "#RESREF#" + GetResRef(oArea) +
            "#X#" + FloatToString(vPosition.x, 5, 2) +
            "#Y#" + FloatToString(vPosition.y, 5, 2) +
            "#Z#" + FloatToString(vPosition.z, 5, 2) +
            "#F#" + FloatToString(fFacing, 5, 2) + "#";
}

// Decodes a location from a string that was encoded with EncodeLocation
// Returns Location() which will be invalid if the area is not found or position invalid.
// * sLocation - Location string to decode
location DecodeLocation(string sLocation)
{
    float fFacing, x, y, z;

    int nIdX, nCount;
    int nStrlen = GetStringLength(sLocation);

    nIdX = FindSubString(sLocation, "#TAG#") + 5;
    nCount = FindSubString(GetSubString(sLocation, nIdX, nStrlen - nIdX), "#");
    string tag = GetSubString(sLocation, nIdX, nCount);

    nIdX = FindSubString(sLocation, "#RESREF#") + 8;
    nCount = FindSubString(GetSubString(sLocation, nIdX, nStrlen - nIdX), "#");
    string resref = GetSubString(sLocation, nIdX, nCount);

    object area = GetFirstArea();
    while (area != OBJECT_INVALID)
    {
        if (GetTag(area) == tag && GetResRef(area) == resref)
            break;
        area = GetNextArea();
    }

    nIdX = FindSubString(sLocation, "#X#") + 3;
    nCount = FindSubString(GetSubString(sLocation, nIdX, nStrlen - nIdX), "#");
    x = StringToFloat(GetSubString(sLocation, nIdX, nCount));

    nIdX = FindSubString(sLocation, "#Y#") + 3;
    nCount = FindSubString(GetSubString(sLocation, nIdX, nStrlen - nIdX), "#");
    y = StringToFloat(GetSubString(sLocation, nIdX, nCount));

    nIdX = FindSubString(sLocation, "#Z#") + 3;
    nCount = FindSubString(GetSubString(sLocation, nIdX, nStrlen - nIdX), "#");
    z = StringToFloat(GetSubString(sLocation, nIdX, nCount));

    nIdX = FindSubString(sLocation, "#F#") + 3;
    nCount = FindSubString(GetSubString(sLocation, nIdX, nStrlen - nIdX), "#");
    fFacing = StringToFloat(GetSubString(sLocation, nIdX, nCount));

    return Location(area, Vector(x, y, z), fFacing);
}