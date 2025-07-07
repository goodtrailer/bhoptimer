#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <regex>
#include <shavit/core>
#include <shavit/hud>
#include <shavit/rankings>
#include <shavit/zones>

#undef REQUIRE_PLUGIN
#include <DynamicChannels>

#define TEXT_BUFFER_LENGTH 32
#define MAP_BUFFER_LENGTH 256

public Plugin myinfo = {
    name = "[shavit] HUD Extras",
    author = "goodtrailer",
    description = "Extra modifications for shavit's bhoptimer hud (shavit-hud)",
    version = "2025.705.0",
    url = "https://github.com/goodtrailer/shavit-hudextras"
};

char gS_MapName[MAP_BUFFER_LENGTH];
int gI_MapTier = 0;

bool gB_DynamicChannels = false;

ConVar gCV_TicksPerUpdate = null;

public void OnPluginStart()
{
	LoadTranslations("shavit-hud.phrases");
	LoadTranslations("shavit-hudextras.phrases");

    char map[MAP_BUFFER_LENGTH];
    GetCurrentMap(map, MAP_BUFFER_LENGTH);
    LessStupidGetMapDisplayName(map, gS_MapName, MAP_BUFFER_LENGTH);
    gI_MapTier = Shavit_GetMapTier(gS_MapName);

	gB_DynamicChannels = LibraryExists("DynamicChannels");
}

public void OnLibraryAdded(const char[] name)
{
	if(StrEqual(name, "DynamicChannels"))
		gB_DynamicChannels = true;
}

public void OnLibraryRemoved(const char[] name)
{
    if(StrEqual(name, "DynamicChannels"))
		gB_DynamicChannels = false;
}

public Action Shavit_OnDrawCenterHUD(int client, int target, char[] buf, int bufLen, huddata_t data)
{
    Action ret = Plugin_Continue;

    char[] copy = new char[bufLen];

    char text[TEXT_BUFFER_LENGTH];
    FormatEx(text, TEXT_BUFFER_LENGTH, "%T: ", "HudTimeText", client);
    int textIdx = StrContains(buf, text);
    if (textIdx >= 0)
    {
        strcopy(copy, bufLen, buf);

        int valIdx = textIdx + strlen(text);
        int endIdx = valIdx;
        while (!IsCharSpace(buf[endIdx]) && buf[endIdx] != '\0')
            endIdx++;
        int valLen = endIdx - valIdx;
        
        int offset = textIdx;

        char original = copy[endIdx];
        copy[endIdx] = '\0';
        strcopy(buf[offset], bufLen - offset, copy[valIdx]);
        copy[endIdx] = original;

        offset += valLen;
        FormatEx(text, TEXT_BUFFER_LENGTH, "%T", "shavit-hudextras_TimeSuffix", client);
        strcopy(buf[offset], bufLen - offset, text);

        offset += strlen(text);
        strcopy(buf[offset], bufLen - offset, copy[endIdx]);

        ret = Plugin_Changed;
    }

    FormatEx(text, TEXT_BUFFER_LENGTH, "%T: ", "HudJumpsText", client);
    textIdx = StrContains(buf, text);
    if (textIdx >= 0)
    {
        strcopy(copy, bufLen, buf);

        int valIdx = textIdx + strlen(text);
        int endIdx = valIdx;
        while (!IsCharSpace(buf[endIdx]) && buf[endIdx] != '\0')
            endIdx++;
        int valLen = endIdx - valIdx;
        
        int offset = textIdx;

        char original = copy[endIdx];
        copy[endIdx] = '\0';
        strcopy(buf[offset], bufLen - offset, copy[valIdx]);
        copy[endIdx] = original;

        offset += valLen;
        FormatEx(text, TEXT_BUFFER_LENGTH, "%T", "shavit-hudextras_JumpsSuffix", client);
        strcopy(buf[offset], bufLen - offset, text);

        offset += strlen(text);
        strcopy(buf[offset], bufLen - offset, copy[endIdx]);

        ret = Plugin_Changed;
    }

    FormatEx(text, TEXT_BUFFER_LENGTH, "%T: ", "HudStrafeText", client);
    textIdx = StrContains(buf, text);
    if (textIdx >= 0)
    {
        strcopy(copy, bufLen, buf);

        int valIdx = textIdx + strlen(text);
        int endIdx = valIdx;
        while (!IsCharSpace(buf[endIdx]) && buf[endIdx] != '\0')
            endIdx++;
        int valLen = endIdx - valIdx;
        
        int offset = textIdx;

        char original = copy[endIdx];
        copy[endIdx] = '\0';
        strcopy(buf[offset], bufLen - offset, copy[valIdx]);
        copy[endIdx] = original;

        offset += valLen;
        FormatEx(text, TEXT_BUFFER_LENGTH, "%T", "shavit-hudextras_StrafeSuffix", client);
        strcopy(buf[offset], bufLen - offset, text);

        offset += strlen(text);
        strcopy(buf[offset], bufLen - offset, copy[endIdx]);

        ret = Plugin_Changed;
    }

    FormatEx(text, TEXT_BUFFER_LENGTH, "%T: ", "HudSpeedText", client);
    textIdx = StrContains(buf, text);
    if (textIdx >= 0)
    {
        strcopy(copy, bufLen, buf);

        int valIdx = textIdx + strlen(text);
        int endIdx = valIdx;
        while (!IsCharSpace(buf[endIdx]) && buf[endIdx] != '\0')
            endIdx++;
        int valLen = endIdx - valIdx;
        
        int offset = textIdx;

        char original = copy[endIdx];
        copy[endIdx] = '\0';
        strcopy(buf[offset], bufLen - offset, copy[valIdx]);
        copy[endIdx] = original;

        offset += valLen;
        FormatEx(text, TEXT_BUFFER_LENGTH, "%T", "shavit-hudextras_SpeedSuffix", client);
        strcopy(buf[offset], bufLen - offset, text);

        offset += strlen(text);
        strcopy(buf[offset], bufLen - offset, copy[endIdx]);

        ret = Plugin_Changed;
    }

    while (ReplaceString(buf, bufLen, "\n\n", "\n") > 0) {}

    return ret;
}

public void Shavit_OnTierAssigned(const char[] map, int tier)
{
    if (strcmp(map, gS_MapName, false) == 0)
        gI_MapTier = tier;
}

public Action Shavit_OnTopLeftHUD(int client, int target, char[] buf, int bufLen, int track, int style)
{
    char[] tl = new char[bufLen];
    strcopy(tl, bufLen, buf);

    int stages = Shavit_GetHighestStage(track);
    if (stages > 0)
    {
        int stage = Shavit_GetClientLastStage(client);
        FormatEx(buf, bufLen, "%s %T %T\n", gS_MapName, "shavit-hudextras_Tier", client, gI_MapTier, "shavit-hudextras_Stage", client, stage, stages);
    }
    else
    {
        FormatEx(buf, bufLen, "%s %T %T\n", gS_MapName, "shavit-hudextras_Tier", client, gI_MapTier, "shavit-hudextras_Linear", client);
    }

    int offset = strlen(buf);
    strcopy(buf[offset], bufLen - offset, tl);

	if (!gB_DynamicChannels)
        return Plugin_Changed;

    if (gCV_TicksPerUpdate == null)
        gCV_TicksPerUpdate = FindConVar("shavit_hud_ticksperupdate");

    int allUpdateCycle = gCV_TicksPerUpdate ? gCV_TicksPerUpdate.IntValue : 5;
    int tlUpdateCycle = 20;
    float epsilon = 0.05;

    SetHudTextParams(
        0.005, 0.005,
        allUpdateCycle * tlUpdateCycle * GetTickInterval() * (1 + epsilon),
        255, 255, 255, 255,
        0, 0.0, 0.0, 0.0
    );
    ShowHudText(client, GetDynamicChannel(5), "%s", buf);
    
    return Plugin_Handled;
}

public Action Shavit_OnDrawKeysHUD(int client, int target, int style, int buttons, float anglediff, char[] buf, int bufLen, int scrolls, int prevscrolls, bool alternate_center_keys)
{
	if (!gB_DynamicChannels)
        return Plugin_Continue;

    SetHudTextParams(
        -1.0, 1.0,
        0.1,
        255, 255, 255, 255,
        0, 0.0, 0.0, 0.0
    );
    ShowHudText(client, GetDynamicChannel(4), "%s", buf);

    return Plugin_Handled;
}
