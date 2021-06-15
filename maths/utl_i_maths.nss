//::///////////////////////////////////////////////
//:: Utility Include: Maths
//:: utl_i_maths.nss
//:://////////////////////////////////////////////
/*
    A number of maths utility functions, for floats and ints.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Returns the higher of a or b
int max(int a, int b);

// Returns the lower of a or b
int min(int a, int b);

// Returns nValue bounded by nMin and nMax
int clamp(int nValue, int nMin, int nMax);

// Returns the higher of a or b
int fmax(float a, float b);

// Returns the lower of a or b
int fmin(float a, float b);

// Floors the given float, eg: 2.9999 = 2
int floor(float fFloat);

// Ceilings the given float, eg: 2.3333 = 3
int ceil(float fFloat);

// Rounds the given float, eg: 2.9999 = 3, and 2.3333 = 2
int round(float fFloat);

// Converts a encoded 0x00000000 hex number to an integer for bitwise operations
// Very useful if used on a 2da field
// * sString - String to convert
int HexStringToInt(string sString);

// Converts a integer number to a 32-character binary string
// Primarily useful for debugging bitwise flags
// * nInteger - integer to transform
string IntToBinaryString(int nInteger);

// Converts an RGB value to a decimal integer
// Useful for using RGB inputs with things like SetFogColor()
int RGBToDecimal(int nRed, int nGreen, int nBlue);

// Returns TRUE if the given string is really a zero "0" string, and not something like
// a empty string, or "00" or similar that StringToInt doesn't inherantly capture.
int IsStringReallyZero(string s);



// Returns the higher of a or b
int max(int a, int b)
{
    return (a > b) ? a : b;
}

// Returns the lower of a or b
int min(int a, int b)
{
    return (a < b) ? a : b;
}

// Returns nValue bounded by nMin and nMax
int clamp(int nValue, int nMin, int nMax)
{
    return (nValue < nMin) ? nMin : ((nValue > nMax) ? nMax : nValue);
}

// Returns the higher of a or b
int fmax(float a, float b)
{
    return (a > b) ? a : b;
}

// Returns the lower of a or b
int fmin(float a, float b)
{
    return (a < b) ? a : b;
}

// Floors the given float, eg: 2.9999 = 2
int floor(float fFloat)
{
    return FloatToInt(fFloat);
}

// Ceilings the given float, eg: 2.3333 = 3
int ceil(float fFloat)
{
    return FloatToInt(fFloat + (IntToFloat(FloatToInt(fFloat)) < fFloat ? 1.0 : 0.0));
}

// Rounds the given float, eg: 2.9999 = 3, and 2.3333 = 2
int round(float fFloat)
{
    return FloatToInt(fFloat + 0.5f);
}

// Converts a encoded 0x00000000 hex number to an integer for bitwise operations
// Very useful if used on a 2da field
// * sString - String to convert
int HexStringToInt(string sString)
{
    sString = GetStringLowerCase(sString);
    int nResult = 0;
    int nLength = GetStringLength(sString);
    int i;
    for (i = nLength - 1; i >= 0; i--) {
        int n = FindSubString("0123456789abcdef", GetSubString(sString, i, 1));
        if (n == -1)
            return nResult;
        nResult |= n << ((nLength - i -1) * 4);
    }
    return nResult;
}

// Converts a integer number to a 32-character binary string
// Primarily useful for debugging bitwise flags
// * nInteger - integer to transform
string IntToBinaryString(int nInteger)
{
    string sResult;
    int i;
    for(i = 1; i <= 32; i++)
    {
        sResult = IntToString(nInteger & 0x01) + sResult;
        nInteger >>= 1;
    }
    return sResult;
}

// Converts an RGB value to a decimal integer
// Useful for using RGB inputs with things like SetFogColor()
int RGBToDecimal(int nRed, int nGreen, int nBlue)
{
    return ((clamp(nRed, 0, 255) * 65536) + (clamp(nGreen, 0, 255) * 256) + clamp(nBlue, 0, 255));
}

// Returns TRUE if the given string is really a zero "0" string, and not something like
// a empty string, or "00" or similar that StringToInt doesn't inherantly capture.
int IsStringReallyZero(string s)
{
    return s != "" && StringToInt(s) == 0 && StringToInt(s + "1") == 1;
}
