public Plugin myinfo = 
{
	name		= "AntiFilterText",
	version		= "1.0",
	description	= "Bypass of ingame word-filter.",
	author		= "NickFox",
	url			= "https://vk.com/nf_dev"
}

public void OnPluginStart()
{
	HookUserMessage(GetUserMessageId("TextMsg"), TextMsgHook, true);
	HookUserMessage(GetUserMessageId("SayText"), SayTextHook, true);
}

char[] Replace(char sBuf[2048]){

		ReplaceString(sBuf, sizeof(sBuf), "а", "a");
		ReplaceString(sBuf, sizeof(sBuf), "о", "o");
		ReplaceString(sBuf, sizeof(sBuf), "с", "c");
		ReplaceString(sBuf, sizeof(sBuf), "е", "e");
		ReplaceString(sBuf, sizeof(sBuf), "р", "p");
		ReplaceString(sBuf, sizeof(sBuf), "у", "y");
		ReplaceString(sBuf, sizeof(sBuf), "х", "x");
		ReplaceString(sBuf, sizeof(sBuf), "п", "n");
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

Action SayTextHook(UserMsg iMsgId, Protobuf hMessage, const int[] iPlayers, int iPlayersNum, bool bReliable, bool bInit)
{
	static char sBuffer[2048];

	hMessage.ReadString("text", sBuffer, sizeof(sBuffer));
	
	hMessage.SetString("text", Replace(sBuffer));
	
	return Plugin_Continue;
}
