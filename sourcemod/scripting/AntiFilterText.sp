bool checked[65];

public Plugin myinfo = 
{
	name		= "AntiFilterText",
	version		= "1.1.1",
	description	= "Bypass of ingame word-filter.",
	author		= "NickFox",
	url			= "https://vk.com/nf_dev"
}

public void OnPluginStart()
{
	HookUserMessage(GetUserMessageId("TextMsg"), TextMsgHook, true);
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

Action TextMsgHook(UserMsg iMsgId, Protobuf hMessage, const int[] iPlayers, int iPlayersNum, bool bReliable, bool bInit)
{
	static char sBuffer[2048];
	
	if(hMessage.ReadInt("msg_dst") == 3)
	{
		hMessage.ReadString("params", sBuffer, sizeof(sBuffer), 0);			
		
		hMessage.SetString("params", Replace(sBuffer), 0);	
	}
	
	return Plugin_Continue;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
	if (checked[client]){
		checked[client]=false;
		return Plugin_Continue;
	}
	
	static char sBuffer[2048];
	FormatEx(sBuffer,sizeof(sBuffer),"%s",sArgs);	
	sBuffer=Replace(sBuffer);
	if (StrContains(sArgs,"@")==0) return Plugin_Continue;
	if (StrEqual(sArgs,sBuffer)) return Plugin_Continue;
	Format(sBuffer,sizeof(sBuffer),"%s %s",command,sBuffer);
	checked[client]=true;
	FakeClientCommandEx(client, sBuffer);
	return Plugin_Stop;
}
