bool checked[65];

public Plugin myinfo = 
{
	name		= "AntiFilterText",
	version		= "1.2",
	description	= "Bypass of ingame word-filter.",
	author		= "NickFox",
	url			= "https://vk.com/nf_dev"
}

public void OnPluginStart()
{
	HookUserMessage(GetUserMessageId("TextMsg"), TextMsgHook, true);
	HookUserMessage(GetUserMessageId("SayText"), SayTextHook, true);
	HookUserMessage(GetUserMessageId("SayText2"), SayText2Hook, true);
	
	CreateTimer(60.0, Timer_AD, _, TIMER_REPEAT);
	
}

public Action Timer_AD(Handle timer)
{
	for (int i = 1;i<=MaxClients;i++) GetCVar(i);						
}

public void SendAD(int client){

	PrintToChat(client, "Для более комфортной игры рекомендуем отключить фильтр цензуры в настройках, либо командой в консоли:\n cl_filtertext_enabled 0 ")
	ClientCommand(client, "play buttons/blip2.wav");

}

char[] Replace(char sBuf[2048]){

		ReplaceString(sBuf, sizeof(sBuf), "а", "ᎴаᎴ");
		ReplaceString(sBuf, sizeof(sBuf), "о", "ᎴоᎴ");
		ReplaceString(sBuf, sizeof(sBuf), "с", "ᎴсᎴ");
		ReplaceString(sBuf, sizeof(sBuf), "е", "ᎴеᎴ");
		ReplaceString(sBuf, sizeof(sBuf), "р", "ᎴрᎴ");
		ReplaceString(sBuf, sizeof(sBuf), "у", "ᎴуᎴ");
		ReplaceString(sBuf, sizeof(sBuf), "х", "ᎴхᎴ");
		ReplaceString(sBuf, sizeof(sBuf), "п", "ᎴпᎴ");
		ReplaceString(sBuf, sizeof(sBuf), "б", "ᎴбᎴ");
		return sBuf;

}

Action TextMsgHook(UserMsg iMsgId, Protobuf hMessage, const int[] iPlayers, int client, bool bReliable, bool bInit)
{	
	if(checked[iPlayers[0]]) return Plugin_Continue;
	
	static char sBuffer[2048];	
	
	if(hMessage.ReadInt("msg_dst") == 3||hMessage.ReadInt("msg_dst") == 4)
	{
		hMessage.ReadString("params", sBuffer, sizeof(sBuffer), 0);			
		
		hMessage.SetString("params", Replace(sBuffer), 0);	
	}
	
	return Plugin_Continue;
}

public void GetCVar(int client){
	if (IsClientInGame(client) && !IsFakeClient(client))
		QueryClientConVar(client, "cl_filtertext_enabled", GotCVar, 0);
}

public void OnClientPutInServer(int client)
{	
	GetCVar(client);
}

GotCVar(QueryCookie cookie, int client, ConVarQueryResult result, char[] cvarName, char[] cvarValue){

	if (StrEqual(cvarValue,"1")) checked[client]=false;
	else checked[client]=true;
	
	if(!checked[client]) SendAD(client);

}

Action SayTextHook(UserMsg iMsgId, Protobuf hMessage, const int[] iPlayers, int iNumPlayer, bool bReliable, bool bInit)
{		
	if(checked[iPlayers[0]]) return Plugin_Continue;
	
	static char sBuffer[2048];

	hMessage.ReadString("text", sBuffer, sizeof(sBuffer));
	
	sBuffer=Replace(sBuffer);
	
	hMessage.SetString("text", sBuffer);
	return Plugin_Continue;
}

Action SayText2Hook(UserMsg iMsgId, Protobuf hMessage, const int[] iPlayers, int iNumPlayer, bool bReliable, bool bInit)
{
	if(checked[iPlayers[0]]) return Plugin_Continue;
	
	static char sBuffer[2048];
	
	hMessage.ReadString("params", sBuffer, sizeof(sBuffer), 1);

	sBuffer=Replace(sBuffer);
	
	hMessage.SetString("params", sBuffer, 1);

	return Plugin_Continue;
}