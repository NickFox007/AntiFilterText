bool checked[65];

public Plugin myinfo = 
{
	name		= "AntiFilterText",
	version		= "1.1",
	description	= "Bypass of ingame word-filter.",
	author		= "NickFox",
	url			= "https://vk.com/nf_dev"
}

public void OnPluginStart()
{
	HookUserMessage(GetUserMessageId("TextMsg"), TextMsgHook, true);
	RegConsoleCmd("say",          Say);
	RegConsoleCmd("say_team",     SayTeam);
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

public Action Say(client, args)
{
	if (checked[client]){
		checked[client]=false;
		return Plugin_Continue;
	}
	checked[client]=true;
	
	static char sBuffer[2048];
	GetCmdArgString(sBuffer, sizeof(sBuffer));
	Format(sBuffer,sizeof(sBuffer),"say %s",Replace(sBuffer));
	FakeClientCommandEx(client, sBuffer);
	return Plugin_Handled;
}

public Action SayTeam(client, args)
{
	if (checked[client]){
		checked[client]=false;
		return Plugin_Continue;
	}
	checked[client]=true;
	
	static char sBuffer[2048];
	GetCmdArgString(sBuffer, sizeof(sBuffer));
	Format(sBuffer,sizeof(sBuffer),"say_team %s",Replace(sBuffer));
	FakeClientCommandEx(client, sBuffer);
	return Plugin_Handled;
}
