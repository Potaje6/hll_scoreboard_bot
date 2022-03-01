# scoreboard_bot
Script to send a message to a discord channel every new game that finished in HLL, working with Maresh HLL_RCON https://github.com/MarechJ/hll_rcon_tool

Dependencies:

```https://github.com/ChaoticWeg/discord.sh.git #clone this discord.sh where this repo is cloned```

Edit scoreboard_bot.sh to add your parameters, at least the discord token but the recommended are the following variables:

```SERVER_URL="https://url.to.your.rcon" #url to your normal url rcon, it will use the api of the score section which is public and display that
SERVER_NAME=Server1 #It will be the name of the user that posts the message
WEBHOOK=https://discord.com/api/webhooks/HERE_GOES_THE_WEBHOOK #the webhook that you got from creating the integration of the channel in your discord
```


How to run:
if you configured all variables above you can just run it alone without parameters, and because it only allows 1 server per run, you can use parameters for the rest of the servers

```./scoreboard_bot/scoreboard_bot.sh -s Server2 -u https://my.second.rcon.url```
