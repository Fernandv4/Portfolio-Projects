const { Client, Events, SlashCommandBuilder, REST, Routes } = require("discord.js");
const { token, clientId, guildId } = require("./config.json");
require('dotenv').config();

const client = new Client({ intents: ["Guilds", "GuildMessages", "MessageContent" ], });
const usrTotals = {};

const {OpenAI} = require("openai");
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

client.once(Events.ClientReady, async (c) => {
  console.log(`Ready! Logging in as ${c.user.username}`);

  const commands = [
    new SlashCommandBuilder()
      .setName("bmi")
      .setDescription("Calculate BMI")
      .addNumberOption((option) =>
        option
          .setName("weight")
          .setDescription("weight in pounds")
          .setRequired(true),
      )
      .addNumberOption((option) =>
        option
          .setName("height")
          .setDescription("height in inches")
          .setRequired(true),
      ),

    new SlashCommandBuilder()
      .setName("cal")
      .setDescription("Calculates recomended proteins, carbs, and fats for the amount of calories entered")
      .addNumberOption((option) =>
        option
          .setName("calories")
          .setDescription("calories wanted")
          .setRequired(true),
      ),

    new SlashCommandBuilder()
        .setName("trackcal")
        .setDescription("Track and view your calorie total")
        .addNumberOption((option) =>
          option.setName("calories")
            .setDescription("Calories to add")
            .setRequired(false),
        ),
        
    new SlashCommandBuilder()
        .setName("motivation")
        .setDescription("Get a motivational quote, optionally based on a theme")
        .addStringOption(option =>
          option
            .setName("theme")
            .setDescription("Optional theme (e.g., perseverance, fitness, discipline)")
            .setRequired(false)
        ),
        
    new SlashCommandBuilder()
        .setName("con-bot")
        .setDescription("Talk to the AI"),

    ].map((command) => command.toJSON()); // Convert commands to JSON for REST

  // Set up REST instance
  const rest = new REST({ version: "10" }).setToken(token);

  try {
    console.log("Clearing old commands...");

    // Clear previous commands for the specific guild
    await rest.put(Routes.applicationGuildCommands(clientId, guildId), {
      body: [],
    });

    console.log("Old commands cleared. Registering new commands...");

    // Register new commands for the guild
    await rest.put(Routes.applicationGuildCommands(clientId, guildId), {
      body: commands,
    });

    console.log("New commands registered.");
    console.log(`Ready! Logged in as ${c.user.username}`);
  } catch (error) {
    console.error("Error updating commands:", error);
  }
  
});//End of client.once on line 10

client.on(Events.InteractionCreate, async (interaction) => {

  const userId = interaction.user.id;
  
  if (!interaction.isChatInputCommand()) return;

  if (interaction.commandName === "bmi") {
    const weight = interaction.options.getNumber("weight");
    const height = interaction.options.getNumber("height");
    const bmi = ((weight / (height * height)) * 703).toFixed(2);

    let result;
    if (bmi < 18.5) result = "underweight";
    else if (bmi < 24.9) result = "normal weight";
    else if (bmi < 29.9) result = "overweight";
    else result = "obese";

    await interaction.reply(
      `\`\`\`
    Your BMI is ${bmi}
    You are considered: ${result}
    \`\`\``);
  }

  if (interaction.commandName === "cal") {
    const calories = interaction.options.getNumber("calories");
    const protein = (calories * 0.3).toFixed(2);
    const carbs = (calories * 0.5).toFixed(2);
    const fat = (calories * 0.2).toFixed(2);

    await interaction.reply(
      `\`\`\`
      For ${calories} calories:
      Protein: ${protein}g
      Carbs:   ${carbs}g
      Fat:     ${fat}g
      \`\`\``
    );
  }

  if (interaction.commandName == "trackcal") {
    const calories = interaction.options.getNumber("calories");

    if (!usrTotals[userId]) {
        usrTotals[userId] = 0;
    }

    if (calories) {
        usrTotals[userId] += calories;
        await interaction.reply(`Added ${calories} calories. New total for today is ${usrTotals[userId]} calories \n ___,,..,,,,_ \n (:( 　　　   ) \n  |:|   ・ω・ |  \n  |:|　  　　 | \n     ''ｰ - - --   `, );
    } else {
        await interaction.reply(`Your current total for the day is ${usrTotals[userId]} calories`,);
    }
  }

  if (interaction.commandName == "motivation") {
    const theme = interaction.options.getString("theme");
    const prompt = theme
      ? `Give me a motivational quote about ${theme}.`
      : "Give me a general motivational quote.";
  
    try {
      await interaction.deferReply();
  
      const response = await openai.chat.completions.create({
        messages: [{ role: "user", content: prompt }],
        model: "gpt-4o-mini",
        max_tokens: 100,
        user: interaction.user.id.toString(),
      });
  
      const quote = response.choices[0].message.content;
      await interaction.editReply(quote);
    } catch (error) {
      console.error("OpenAI error in motivation command:", error);
  
      if (interaction.replied || interaction.deferred) {
        await interaction.editReply("Sorry, I couldn't fetch a motivational quote right now.");
      } else {
        await interaction.reply("Sorry, I couldn't fetch a motivational quote right now.");
      }
    }
  }

  if (interaction.commandName === "con-bot") {
    await interaction.reply("Talk to the bot! Mention me in a message to get a response.");
  }

});

client.on("messageCreate", async (msg) => {
  if (msg.author.bot) return;
  if (msg.mentions.has(client.user)) {
    const userMessage = msg.content.replace(/<@\d+>/g, "");

    if(!userMessage) {
      return msg.reply("Nothing to respond to try asking me for something.")
    }
   

    let response = await msg.reply("Getting answer...");

    try {
      const chatCompletion = await openai.chat.completions.create({
        messages: [{ role: "user", content: msg.content }],
        model: "gpt-4o-mini",
        max_tokens: 250,
        user: msg.author.id.toString(),
      });

      const aiResponse = chatCompletion.choices[0].message.content;
      await response.edit(aiResponse);
    } catch (error) {
      if (error.code === 'insufficient_quota' || error.status === 429) {
        await response.edit("Sorry, I've hit a rate limit or quota. Please try again later.");
      } else {
        await response.edit("Sorry, I couldn't get an answer right now.");
      }
      console.error("Error with OpenAI:", error);
    }
  }
});

client.login(token);

process.on("SIGINT", () => {
  console.log("Logging out...");
  client.destroy(); // Closes the WebSocket connection
  process.exit();   // Exits the program
});

process.on("exit", () => {
  console.log("Process is exiting...");
  client.destroy();
});