-- 
-- Abstract: RandGenUtil - Random Generation Utilities 
--  
-- Version: 1.0
-- 

local Quest = require ("quest")
local Thing = require ("thing")
local Place = require ("place")
local Npc = require("npc")
local Encounter = require("encounter")

local syllables = { "a","al","ald","ale","an","and","ap","ar","bal","ban","bar","bert","bin","bon","cha","cid","con",
					"crys","dar","de","dor","e","ed","el","em","er","fer","foul","fred","ga","gar","gib","gir","god",
					"gra","gre","guet","ha","han","her","hu","i","ian","ias","if","in","ing","ip","is","jer","jo","jon",
					"kal","kin","kor","la","le","lo","lou","mich","mo","nar","ne","o","on","pha","raf","ram","ret","reu",
					"rex","ri","rick","rot","ryk","sa","toll","u","us","y" }
local rarerSyllables = { "fowk", "jab", "nais", "pho","pip","que","zi"}

local dwarfMaleSyllables = {"ad", "am", "ang", "al", "arm", "bae", "bar", "beld", "ben", "bom", "bram", "brek", "brot", "bur", "dain", "dar", "dor", 
							"dir", "drak", "dru", "dur", "dus", "eb", "erk", "far", "gam", "gan", "gim", "gin", "grim", "guld", "gurn", 
							"har", "kil", "li", "lo", "mas", "mek", "muir", "mus", "num", "nam", "olm", "on", "ram", "ran", "ren", "rik", 
							"ros", "thar", "thor", "tor", "ty", "us", "un", "ulm", "urn", "vor", "vun"}
local dwarfFemaleSyllables = {}

local elfMaleSyllables = {"act", "ae", "aes", "alor", "ara", "aric", "ash", "bryn", "dae", "del", "ela", "elis", "elm", "en", "er", "erin", 
						  "far", "fen", "fil", "fin", "glen", "glyn", "harn", "ian", "illin", "ise", "is", "isa", "isi", "ithas", "kelm", "ka", "ki", 
						  "lam", "lem", "lian", "lim", "lin", "mira", "nae", "nam", "nar", "oli", "or", "oran", "ren", "ric", "ryc", "ryn", 
						  "sen", "sil", "song", "syl", "taris", "val", "van", "vir", "yar"}
local gnomeMaleSyllables = {"al", "ak", "bal", "bar", "bel", "ben", "berry", "bif", "bim", "bo", "bof", "bom", "bonk", "boddy", "bus", "byn", "dim", 
							"don", "eddo", "eld", "err", "far", "fiddle", "fon", "foodle", "frug", "gar", "ger", "gim", "jeb", "kel", "kin", "kul", 
							"ky", "len", "lic", "mul", "nam", "nock", "shan", "sul", "tre", "tri", "ven", "weth", "wen", "wil", "wut", "zaph", 
							"zeph", "zip", "zirth"}
local halforcMaleSyllables = {"ago", "agu", "ak", "bor", "bur", "dra", "dro", "du", "durk", "gash", "gok", "gor", "gru", "gro", "gur", "grom", "grr", 
							  "gurm", "gun", "kut", "mag", "mog", "mok", "muk", "mur", "nok", "nuk", "ok", "or", "ork", "san", "son", "tar", "thar", 
							  "to", "uda", "ug", "ugor", "uma", "ur", "uk", "vug", "vok", "vuk", "war", "'"}
local halflingMaleSyllables = {"a", "ain", "an", "am", "ban", "byn", "dan", "den", "dar", "der", "fal", "fel", "fin", "flyn", "fon", "en", "er", 
							  "hal", "han", "hem", "hen", "hin", "hip", "en", "ian", "in", "jan", "jen", "jin", "kal", "kel", "nem", "nom", "man", 
							  "min", "ori", "pan", "pen", "per", "rin", "ry", "ver", "wen", "yan", "yar", "zan", "zin", "zip"}
local dragonbornMaleSyllables = {"aar", "ak", "al", "ar", "arc", "arj", "arr", "ash", "bal", "bhar", "bi", "da", "dinn", "don", "ed", "eh", "esh", 
								 "far", "gar", "ghe", "han", "hav", "hed", "hen", "hes", "hun", "id", "iv", "kan", "kri", "la", "lar", "lor", "me", 
								 "med", "mesh", "ned", "onn", "pand", "pat", "ra", "rai", "rash", "rho", "ri", "rin", "rinn", "sam", "san", "she", 
								 "so", "tar", "tor"}
local tieflingMaleSyllables = {"aet", "ai", "ak", "amn", "an", "ar", "ark", "baal", "bael", "bar", "belx", "cas", "dai", "dhar", "dham", "eb", "er", 
							   "hor", "ia", "ich", "ir", 
							   "ira", "kai", "kal", "kas", "khar", "kil", "kos", "ky", "lius", "lok", "mal", "mav", "mel", "mem", "mon", "mor", "mos", 
							   "mus", "nep", "non", "nos", "om", "on", "os", "rios", "ris", "rius", "ron", "rut", "sal", "thor", "thos", "tor", "uri", 
							   "us", "val", "vel", "ven", "vius", "xes", "xi", "xire", "xus", "zher", "zire"}
local tieflingVirtues = {"weary", "glory", "hope", "art", "creed", "sorrow", "poetry", "excellence", "entropy", "bright", "exceptional", "different", 
	                     "harmony", "ennui", "hate", "gladness", "trickery", "immortal", "torment", "song", "ashes", "comfort", "freedom", "ideal", 
	                     "martial", "arcane", "vice", "recovery", "glory", "compassion", "redemption", "master", "terror", "fear", "passion", "sly", 
	                     "lust", "happy", "ambition", "pain", "hero", "truth", "wit", "fresh", "cheer", "rare", "journey", "scout", "archer", 
	                     "treaty", "darkness", "sanctity", "voyage", "travels", "epic", "temple", "venture", "odyssey", "idea", "thought", "hazard", 
	                     "peril", "expedition", "passage", "tour", "trek", "wander", "galavant", "jaunt"}
local tieflingSuffixSurnames = {"a", "aad", "aadi", "aag", "aal", "aar", "ad", "ag", "aggi", "ago", "allen", 
								"amu", "and", "ark", "as", "askes", "askit", "aus", "avord", "ban", "bar", 
								"bard", "barn", "basti", "bay", "beg", "bend", "ber", "bert", "bes", "bind", 
								"biog", "bis", "bo", "bor", "bord", "bos", "brata", "bred", "bret", "bril", 
								"brod", "cald", "calt", "cas", "casc", "chet", "cith", "cold", "coten", 
								"coyle", "crig", "dae", "dama", "dan", "dar", "das", "de", "deag", "ded", 
								"dem", "denrak", "der", "dhar", "dim", "dion", "dond", "dot", "drae", "drake", 
								"drem", "drend", "drer", "dria", "drim", "dring", "drird", "dro", "du", "duk", 
								"dull", "ea", "easto", "ecni", "ecro", "ed", "eg", "eis", "eka", "ekar", "el", 
								"elli", "elt", "emi", "eras", "err", "es", "esa", "et", "eth", "fad", "fadn", 
								"fal", "fam", "far", "feka", "fem", "femme", "fetra", "fier", "fis", "flaor", 
								"fo", "freen", "gan", "gand", "gavor", "gerd", "gim", "gind", "gird", "gon", 
								"grec", "gro", "groft", "grove", "guk", "ha", "han", "hat", "hav", "heart", 
								"hel", "helva", "hico", "hion", "hit", "hiv", "hog", "hom", "hov", "hu", "hul", 
								"i", "ia", "iab", "iagi", "iamit", "ian", "ias", "iat", "ib", "ibone", "ice", 
								"igior", "igro", "ika", "ile", "in", "ing", "ior", "ise", "issot", "ista", "iteth", 
								"ius", "ivre", "jal", "jan", "jhyph", "jur", "ka", "kal", "kan", "kar", "kas", 
								"kaz", "kec", "keth", "ki", "kic", "kik", "kil", "kin", "kior", "kir", "koca", 
								"kon", "kra", "kragg", "kre", "krec", "krev", "kror", "krun", "kryl", "kryt", "ku", 
								"kurt", "ky", "lab", "lap", "lat", "lay", "le", "lech", "line", "lir", "liy", 
								"llae", "lus", "lyr", "maas", "mal", "mar", "me", "mec", "med", "medras", "men", 
								"menstu", "merny", "mic", "min", "mir", "mirt", "mon", "mort", "mull", "munt", 
								"mus", "nar", "nat", "ne", "neb", "nec", "net", "nid", "nok", "non", "nor", "nos", 
								"note", "o", "odo", "of", "ofro", "ograt", "olas", "om", "onas", "ond", "ong", 
								"ordik", "osaadrind", "ot", "oth", "ov", "pak", "pam", "pan", "pia", "pim", "pisor", 
								"rac", "ralla", "ralt", "rand", "rar", "ras", "reald", "reav", "rec", "rel", "relt", 
								"rev", "revi", "riam", "rib", "ric", "rid", "riggi", "rik", "ril", "rila", "rild", 
								"rin", "rinun", "rir", "ris", "rish", "rit", "rith", "rive", "role", "rolt", "ron", 
								"rond", "rord", "ros", "ru", "ruc", "rur", "rus", "ryna", "sa", "sab", "saf", "sav", 
								"sek", "sen", "sev", "shak", "shall", "sharr", "she", "shem", "shev", "shiald", "shir", 
								"shis", "shit", "shugget", "sic", "siend", "sind", "sing", "sir", "siy", "ska", "ski", 
								"son", "sris", "sry", "stear", "steath", "stet", "stiar", "stir", "sto", "strand", 
								"stun", "su", "ta", "taare", "tag", "tan", "tarnet", "tasim", "tav", "te", "tec", 
								"temu", "teny", "ter", "thame", "tho", "tia", "tik", "tisyr", "tit", "to", "tode", 
								"tonst", "tor", "tre", "trim", "trit", "tuld", "tull", "ugac", "uk", "une", "uns", 
								"usia", "usk", "uth", "uti", "vaal", "vad", "vaelt", "val", "van", "varog", "vart", 
								"vas", "vat", "vay", "veg", "veld", "velo", "vem", "ver", "vet", "vild", "vir", "von", 
								"vord", "voth", "voy", "vud", "vuma", "vus", "vy", "vyrr", "worl", "xi", "yan", "ylle", 
								"yn", "yr", "zam", "zan", "zat", "zav", "zavo", "ze", "zer", "zher", "zim", "zine", "zo", 
								"zokri", "zoor", "zus"}
local adjectives = {"old", "forgotten", "iron", "golden", "pleasant", "dusty", "dark", "gloomy", "bright",
					"murky", "misty", "sullen", "wintry", "burned", "crumbling", "shadowy", "night" }
local colorNames = {"blue", "green", "white", "red", "black", "grey", "gold", "purple", "orange", "yellow", "emerald", "rose", 
					"turquoise", "amber", "ruby", "silver", "diamond", "opal", "ebony", "ivory", "platinum", "chromatic", 
					"copper", "electrum", "iron" }
local regionNames = {"deep", "desert", "downs", "fens", "forest", "grasslands", "guard", "gulf", "hills", 
				     "kingdom", "lands", "marches", "marsh", "mountains", "pass", "peaks", "plains", "spire", 
				     "vale", "valley", "rift", "territory", "warrens", "wastes"}
local lakeNames = {"lake", "pond", "falls", "slough", "reservoir", "millpond", "river", "stream", "depths", 
				   "shallows", "lagoon", "basin", "shallows", "cove", "loch", "brook"}
local cryptNames = {"catacombs", "chambers", "cemetary", "crypt", "mausoleum", "sepulcher", "tomb", "undercroft"}
local seaNames = {"bay", "expanse", "gulf", "ocean", "sea", "strait"}
local townNames = {"city", "field", "glen", "hamlet", "haven", "square", "town", "township", "village"} 
local dungeonNames = {"caverns", "caves", "ruins", "temple", "forge"}
local keepNames = {"abbey", "castle", "citadel", "fort", "fortress", "hold", "keep", "stronghold"}
local forestNames = {"fens", "forest", "glade", "glen", "thicket", "wood"}
local roadNames = {"road", "path", "trail", "avenue", "course", "highway", "lane", "street", "thoroughfare",
					"track", "way"}


local thingNamesWeapon = {"club", "greatclub", "javelin", "light hammer", "mace", "sickle", "dart", "sling",
						  "longsword", "shortsword", "rapier", "cutlass", "greatsword", "scimitar", "battleaxe", 
						  "shortbow", "hand crossbow", "light crossbow", "longbow", "blowgun", "heavy crossbow", "great bow",
						  "dagger", "quarterstaff", "wand", "rod", "orb", "net",
						  "battleaxe", "greataxe", "handaxe", "Dwarven Urgrosh", "Elven Crescent Blade",
						  "spear", "halberd", "glaive", "trident", "flail", "lance", "maul", "spiked chain", "war pick",
						  "warhammer", "whip", "war scythe"
						   }
local thingNamesArmor = { "shield", "buckler", "tower shield",
						  "armor", "breast plate", "leather armor", "padded leather", "studded leather", "chain shirt", 
						  "hide armor", "chain mail", "scale mail", "plate mail", "half plate", "ring mail", "scale mail",
						  "helmet", "helm", "circlet", "hood",
						  "boots", "gloves", "belt", "bracers", "gauntlets", "cloak"}
local thingNamesHerb = {"dried flowers", "Bumbleberry", "pipeweed", "dandelions", "Dumgi Fungi", "Fizzberry", "Gluttonberry", 
						"Golden Mushroom", "Mithrenfire", "Mumbleberry", "Moon Fruit", "Ramstalk", "Slumberberry", "rations",
					    "1 lb. of wheat", "1 lb. of flour", "one chicken", "1 lb. of salt", "1 lb. of iron", "1 sq. yd. of canvas",
					    "1 lb. of copper", "1 sq. yd. of cotton cloth", "1 lb. of ginger", "one goat", "1 lb. of cinnamon",
					    "1 lb. of pepper", "one sheep", "1 lb. of cloves", "one pig", "1 lb. of silver", "1 sq. yd. of linen",
					    "1 sq. yd. of silk", "one cow", "1 lb. of saffron", "one ox", "1 lb. of gold", "1 lb. of platinum"}
local thingNamesTreasure = {"necklace", "ring", "brooch", "crown", "bracelet",
							"treasure chest", "gem", "gold", "jewels", "chalice",
							"artwork", "painting", "sculpture"}
local thingNamesCommon = {"Abacus", "Acid", "Alchemist’s fire (flask)", "Arrows", "Blowgun needles", "Crossbow bolts", 
                          "Sling bullets", "Amulet", "Antitoxin (vial)", "Crystal", "Orb", "Rod", "Staff", "Wand", "Backpack", 
                          "Ball bearings (bag of 1,000)", "Barrel", "Basket", "Bedroll", "Bell", "Blanket", "Block and tackle", 
                          "Book", "Bottle, glass", "Bucket", "Caltrops (bag of 20)", "Candle", "Case, crossbow bolt", 
                          "Case, map or scroll", "Chain (10 feet)", "Chalk (1 piece)", "Chest", "Clothes, common", 
                          "Clothes, costume", "Clothes, fine", "Clothes, traveler’s", "Component pouch", "Crowbar", 
                          "Sprig of mistletoe", "Totem", "Wooden staff", "Yew wand", "Emblem", "Fishing tackle", 
                          "Flask", "tankard", "Grappling hook", "Hammer", "Hammer, sledge", "Holy water (flask)", "Hourglass", 
                          "Hunting trap", "Ink (1 ounce bottle)", "Ink pen", "Jug", "pitcher", "Kit, climber’s", "Kit, disguise", 
                          "Kit, forgery", "Kit, herbalism", "Kit, healer’s", "Kit, mess", "Kit, poisoner’s", "Ladder (10-foot)", 
                          "Lamp", "Lantern, bullseye", "Lantern, hooded", "Lock", "Magnifying glass", "Manacles", "Mirror, steel", 
                          "Oil (flask)", "Paper (one sheet)", "Parchment (one sheet)", "Perfume (vial)", "Pick, miner’s", "Piton", 
                          "Poison, basic (vial)", "Pole (10-foot)", "Pot, iron", "Potion of healing", "Pouch", "Quiver", 
                          "Ram, portable", "Rations (1 day)", "Reliquary", "Robes", "Rope, hempen (50 feet)", "Rope, silk (50 feet)", 
                          "Sack", "Scale, merchant’s", "Sealing wax", "Shovel", "Signal whistle", "Signet ring", "Soap", "Spellbook", 
                          "Spikes, iron (10)", "Spyglass", "Tent, two-person", "Tinderbox", "Torch", "Vial", "Waterskin", "Whetstone",
                      	  "Alchemist’s supplies", "Brewer’s supplies", "Calligrapher’s supplies", 
						  "Carpenter’s tools", "Cartographer’s tools", "Cobbler’s tools", "Cook’s utensils", 
						  "Glassblower’s tools", "Jeweler’s tools", "Leatherworker’s tools", "Mason’s tools", 
						  "Painter’s supplies", "Potter’s tools", "Smith’s tools", "Tinker’s tools", 
						  "Weaver’s tools", "Woodcarver’s tools", "Navigator’s tools", "Thieves’ tools", 
						  "Dice set", "Playing card set", "Bagpipes", "Drum", "Dulcimer", "Flute", "Lute", 
						  "Lyre", "Horn", "Pan flute", "Shawm", "Viol"}
local thingNamesPotion = {"Potion of Healing", "Potion of Giant Strength"}
local thingNamesMagic = {"Boots of Speed", "+1 Weapon", "Sword of Sharpness"}
local thingNamesWondrous = {"Ioun Stone", "Oil of Slipperiness"}

local adversaries = {"orcs", "a dragon", "kobolds", "bandits", "mercenaries", "giants", "trolls",
					 "a rust monster", "minotaurs", "drow", "duergar"}

local obstacles = {"washed out road", "ruined bridge", "flooded river", "slaughtered caravan"}


local traits = {{"fat","chubby","obese","pot-bellied","gaunt","bean-pole","skinny","well-proportioned"}, 
				{"tall", "short"}, {"button-nose", "hawkish", "long nosed", "broad nosed", "slender nose"},
				{"clean shaven", "mustache", "beard", "goatee", "scruff", "stubble"}, 
				{"piercing eyes", "dead eyes" }, {"amiable", "gruff", "friendly", "stern"}}
local classes = {"Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", 
				 "Warlock", "Wizard"}
local races = {"Dragonborn", "Dwarf", "Elf", "Gnome", "Halfling", "Half-Elf", "Half-Orc", "Human", "Tiefling"}
local placeTypes = {"Town", "Dungeon", "Crypt", "Keep", "Forest", "Lake", "Sea", "Road", "Region"}
local traitsTable = {}
traitsTable['Body'] = {"fat","chubby","obese","pot-bellied","gaunt","bean-pole","skinny","well-proportioned", 
					   "stocky", "broad shouldered", "lanky","muscled", "heavily muscled"}
traitsTable['Height'] = {"very tall", "tall", "short", "very short"}
traitsTable['Nose'] = {"clean shaven", "mustache", "beard", "goatee", "scruff", "stubble", "sideburns", 
					   "mutton chop sideburns", "well-trimmed mustache", "oiled beard", "waxed mustache"}
traitsTable['Eyes'] = {"piercing eyes", "dead eyes", "sullen eyes", "blue eyes", "green eyes", "large eyes", "brown eyes" }
traitsTable['Disposition'] = {"amiable", "gruff", "friendly", "stern"}
traitsTable['Extras'] = {"Always bored","Angry drunk","Annoyingly Cryptic","Avant-garde","Bigoted","Bloody-Minded",
	"Boastful","Bookworm","Bossy","Bully","Calculating","Can-do attitude","Chatterbox","Chirpy","Collects small animals",
	"Compulsive Liar","Condescending","Conniving","Conspiracy theorist","Creep","Decadent","Ditz","Egomaniac",
	"Exquisite dresser","Extravagant","Fanatically loyal","Fast-talker","Femme Fatale","Fiercely ambitious",
	"Fits of melancholy","Flamboyant","Folksy Wisdom","Gossip","Hard-boiled","Hears voices","Hillbilly","Hothead",
	"Hypochondriac","Iconoclast","Idealistic","Illiterate","Incredibly persistent","Insightful observer","Into crystals",
	"Jack of all Trades","Jerk","Klutz","Knows everybody","Life of the party","Love-struck","Mad genius",
	"Magnetic Personality","Manic","Master Orator","Militantly Vegan","Misanthrope","Miser","Mopey","Naïve","Nerd",
	"No-nonsense","Obsessive","Old Fart","Overeducated","Paranoid","Perfect Manners","Pouty","Power-hungry","Prickly",
	"Proselytizer","Ruthless","Sadist","Self-destructive","Self-important","Self-pitying","Senile","Serene",
	"Shameless Flirt","Slacker","Slimy","Slovenly","Snarky","Snitch","Snob","Social butterfly","Sophist","Spacey",
	"Terrible memory","Thick","Toady","Totally unreliable","Twitchy","Vain","Vengeful","Village idiot","Well-Travelled",
    "Whiner","Wild Child","Wisecracking","World-weary" }
traitsTable['Background'] = {"Drug addict","Drunk","Fighter","Has a vision for the future","Has achieved many things in life",
					"Has good taste","Hasn't achieved much in life","Haunted by a ghost","Heart broken","Popular",
					"Professional","Respected in the community","Rich","Veteran","Wealthy","Abandoned"}
traitsTable['Physical'] = {"Abusive","Action oriented","Addict","Aggressive","Alluring","Animated","Rapturous","Rugged",
						"Short","Strong","Well-groomed","Able","Accident prone","Adorable","Always hungry","Beautiful",
						"Dirty","Diseased","Filthy","Hardy","Weak constitution","Healthy","Hormonal","Ill","Lean","Nimble",
						"Obese","Overweight","Plain","Tall","Ugly","Unclean","Young"}
traitsTable['Social'] = {"Accepting","Accommodating","Accomplished","Adulterer","Adventurous","Aesthetic","Affable",
						"Affected","Affectionate","Agnostic","Agreeable","Altruistic","Amateurish demeanor","Ambiguous",
						"Ambivalent","Amiable","Amused","Amusing","Annoying","Antagonistic","Anti-social","Apologetic",
						"Appreciative","Approachable","Argumentative","Arrogant"}
traitsTable['Mental'] = {"Abrasive","Abrupt","Absent-minded","Adamant","Adaptable","ADHD","Afraid","Afraid of commitment",
		"Afraid of ghosts","Agonized","Alcoholic","Alert","Aloof","Always late","Ambitious","Analytical","Angry","Annoyed",
		"Anti-intellectual","Anxious","Apathetic","Apprehensive","Arbitrary","Aristocratic","Art collector","Articulate",
		"Artistic","Artless","Ashamed","Aspiring","Assertive","Astonished","Astounded","Astute","Attentive","Attentive to others",
		"Audacious","Austere","Authoritarian","Authoritative","Autocratic","Avoids conflict","Aware of own limitations","Awed",
		"Awful","Awkward","Babbling","Babyish","Backstabber","Bashful","Belligerent","Benevolent","Betrayed","Bewildered",
		"Bewitching","Biter","Bitter","Blames others","Blas▒","Blissful","Blowhard","Boastful","Boisterous","Bold","Boorish",
		"Bored","Boring","Bossy","Boundless","Bragging","Brainy","Brash","Bratty","Brave","Brazen","Bright","Brilliant",
		"Broad-minded","Brotherly","Brutish","Bubbly","Bully","Burdened","Busy","Calculating","Callous","Calm","Candid",
		"Capable","Capricious","Captivated","Carefree","Careful","Careless","Careless of social rules","Caring","Caustic",
		"Cautious","Changeable","Charismatic","Charitable","Charming","Chaste","Chatty","Cheat","Cheerful","Cheerless","Childish",
		"Chivalrous","Civilised","Classy","Clean","Clever","Close","Closed","Clumsy","Coarse","Cocky","Coherent","Cold",
		"Cold hearted","Combative","Comfortable","Committed","Communicative","Compassionate","Competent","Competitive",
		"Complacent","Compliant","Compulsive","Compulsive liar","Conceited","Concerned","Concrete thinking","Condemned",
		"Condescending","Confident","Conformist","Confused","Congenial","Connoisseur of good drink","Connoisseur of good food",
		"Conscientious","Conservative","Considerate","Consistent","Conspicuous","Conspiracy theorist","Constricting","Constructive",
		"Content","Contented","Contrarian","Contrary","Contrite","Controlling","Conventional","Conversational","Cool","Cooperative",
		"Coquettish","Cosmopolitan","Courageous","Courteous","Covetous","Cowardly","Cowering","Coy","Crabby","Crafty","Cranky","Crazy",
		"Creative","Credible","Creepy","Critical","Cross","Crude","Cruel","Crushed","Cuddly","Culpable","Cultured","Cunning",
		"Curious","Cutthroat","Cynical","Dainty","Dangerous","Daredevil","Daring","Dark","Dashing","Dauntless","Dazzling",
		"Debonair","Deceitful","Deceiving","Decent","Decisive","Decorous","Dedicated","Defeated","Deferential","Defiant",
		"Delegates authority","Deliberate","Deliberative","Delicate","Delighted","Delightful","Delusional about own skills",
		"Demanding","Demonic","Dependable","Dependent","Depraved","Depressed","Depressive","Deranged","Desirous","Despairing",
		"Despicable","Despondent","Destructive","Detached","Detail-oriented","Determined","Develops close friendships","Devilish",
		"Devious","Devoted","Devout","Dictatorial","Diffident","Dignified","Diligent","Diminished","Diplomatic","Direct",
		"Directionless","Disaffected","Disagreeable","Discerning","Disciplined","Discontented","Discouraged","Discreet",
		"Disgusting","Dishonest","Disillusioned","Disinterested","Disloyal","Dismayed","Disorderly","Disorganized","Disparaging",
		"Disregards rules","Disrespectful","Dissatisfied","Dissident","Dissolute","Distant","Distracted","Distraught","Distressed",
		"Distrustful","Disturbed","Divided","Docile","Does what is convenient","Does what is necessary or right","Dogmatic",
		"Dominant","Domineering","Dorky","Doubtful","Dowdy","Downtrodden","Draconian","Dramatic","Dreamer","Dreamy","Dreary",
		"Driven","Dubious","Dull","Dumb","Dutiful","Dynamic","Eager","Easily embarrassed","Easily led","Easily upset","Easygoing",
		"Eccentric","Ecstatic","Educated","Effervescent","Efficient","Egocentric","Egotistic","Egotistical","Elated","Electrified",
		"Eloquent","Elusive","Embarrassed","Embittered","Embraces change","Eminent","Emotional","Emotionally stable","Empathetic",
		"Empty","Enchanted","Enchanting","Encouraging","Enduring","Energetic","Engaging","Enigmatic","Enjoys a good argument",
		"Enjoys a good brawl","Enjoys a little friendly competition","Enterprising","Entertaining","Enthusiastic","Entrepreneurial",
		"Envious","Equable","Erratic","Ethical","Evasive","Evil","Exacting","Exasperated","Excellent","Excessive","Excitable",
		"Excited","Exclusive","Exhausted","Expansive","Expedient","Experimental","Expert","Expressive","Extravagant","Extraverted",
		"Extreme","Exuberant","Fabulous","Faces reality","Facetious","Faded","Failure","Fair","Faith in oneself","Faith in others",
		"Faith in self","Faithful","Faithless","Fake","Fanatical","Fanciful","Fantastic","Fascinated","Fast learner","Fastidious",
		"Fatalistic","Fatigued","Fawning","Fearful","Fearless","Feisty","Ferocious","Fidgety","Fierce","Fiery","Fine","Finicky",
		"Fitness fanatic","Flagging","Flakey","Flamboyant","Flashy","Fleeting","Flexible","Flighty","Flippant","Flirtatious",
		"Flirty","Flustered","Focused","Follower","Follows rules","Foolhardy","Foolish","Forceful","Forgetful","Forgiving","Formal",
		"Forthright","Fortunate","Foul","Fragile","Fragmented","Frank","Frantic","Frazzled","Free of guilt","Free thinking","Fresh",
		"Fretful","Friendly","Frightened","Frigid","Frugal","Frustrated","Fuddy duddy","Fun","Fun loving","Fun to be around","Funny",
		"Furious","Furtive","Fussy","Gabby","Garrulous","Gaudy","Generous","Genial","Gentle","Genuine","Giddy","Giggly",
		"Gives others their freedom","Gives up easily","Giving","Glad","Glamorous","Gloomy","Glorious","Glum","Glutton","Gluttonous",
		"Goal orientated","Good","Good communicator","Good listener","Good-natured","Good-spirited","Goofy","Graceful","Gracious",
		"Grandiose","Grateful","Gratified","Greedy","Gregarious","Grief","Grieving","Groovy","Grotesque","Grouchy","Grounded",
		"Group-oriented","Growly","Gruesome","Gruff","Grumpy","Guarded","Guileless","Guilt prone","Guilt ridden","Guilty","Gullible",
		"Haggard","Haggling","Handsome","Happy","Happy go lucky","Hard","Hard working","Harmonious","Harried","Harsh",
		"Has clear goals","Hassled","Hateful","Haughty","Heartless","Heavenly","Heavy hearted","Hedonistic","Helpful","Helpless",
		"Heroic","Hesitant","High","High energy","High self esteem","High social status","Hilarious","Hobbyist","Holy","Homeless",
		"Homesick","Honest","Honor bound","Honorable","Hopeful","Hopeless","Horrible","Hospitable","Hostile","Hot headed","Huffy",
		"Humble","Humorous","Hurt","Hypocritical","Hysterical","Ignorant","Ignored","Ill-bred","Imaginative","Immaculate","Immature",
		"Immobile","Immodest","Impartial","Impatient","Impeccable","Imperial","Impersonal","Impolite","Impotent","Impoverished",
		"Impractical","Impressed","Improves self","Impudent","Impulsive","In harmony","Inactive","Incoherent","Incompetent",
		"Inconsiderate","Inconsistent","Indecisive","Independent","Indifferent","Indiscrete","Indiscriminate","Individualistic",
		"Indolent","Indulgent","Industrious","Inefficient","Inept","Infantile","Infatuated","Inflexible","Informed","Infuriated",
		"Inherited success","Inhibited","Inhumane","Inimitable","Innocent","Inquisitive","Insane","Insecure","Insensitive",
		"Insightful","Insincere","Insipid","Insistent","Insolent","Insouciant","Inspired","Instinctive","Insulting","Intellectual",
		"Intelligent","Intense","Interested","Interrupting","Intimidated","Intimidating","Intolerant","Intrepid","Introspective",
		"Introverted","Intuitive","Inventive","Involved","Irresolute","Irresponsible","Irreverent","Irritable","Irritating",
		"Isolated","Jackass","Jaded","Jealous","Jittery","Joking","Jolly","Jovial","Joyful","Joyous","Judgmental","Jumpy","Just",
		"Keen","Kenderish","Kind","Kind hearted","Kittenish","Knowledgeable","Lackadaisical","Lacking","Laconic","Languid",
		"Lascivious","Late","Lax","Lazy","Leader","Leaves things unfinished","Lecherous","Lethargic","Level","Lewd","Liar",
		"Liberal","Licentious","Light-hearted","Likeable","Likes people","Limited","Lineat","Lingering","Lively","Logical",
		"Lonely","Longing","Loquacious","Lordly","Loud","Loudmouth","Lovable","Love","Lovely","Lover, not a fighter",
		"Loves challenge","Loving","Low confidence","Low drive","Low social status","Lowly","Loyal","Loyal to boss",
		"Loyal to community","Loyal to family","Loyal to friends","Lucky","Lunatic","Lusty","Lying","Macho","Mad","Malevolent",
		"Malice","Malicious","Maniacal","Manic","Manipulative","Mannered","Mannerly","Masochistic","Materialistic","Matronly",
		"Matter-of-fact","Mature","Maudlin","Mean","Mean-spirited","Meek","Megalomaniac","Melancholy","Melodramatic",
		"Mentally slow","Merciful","Mercurial","Messy","Meticulous","Mild","Mischievous","Miserable","Miserly","Mistrusting",
		"Modern","Modest","Moody","Moping","Moralistic","Morbid","Motherly","Motivated","Muddled goals","Murderer","Mysterious",
		"Mystical","Nagging","Naive","Narcissistic","Narrow-minded","Nasty","Natural leader","Naughty","Neat",
		"Needs social approval","Needy","Negative","Negligent","Nervous","Neurotic","Never gives up","Never hungry","Nibbler",
		"Nice","Night owl","Nihilistic","Nit picker","No purpose","No self confidence","No-nonsense","Noble","Noisy",
		"Non-committing","Nonchalant","Nonconforming","Nostalgic","Nosy","Not trustworthy","Nuanced","Nuisance","Nurturing","Nut",
		"Obedient","Obliging","Oblivious","Obnoxious","Obscene","Obsequious","Observant","Obsessed","Obsessive about something",
		"Obstinate","Odd","Odious","Open","Open to change","Open-minded","Opinionated","Opportunistic","Oppositional","Optimistic",
		"Orcish","Orderly","Organized","Ornery","Ossified","Ostentatious","Others can't be relied on","Outgoing","Outraged",
		"Outrageous","Outspoken","Over wrought","Overbearing","Overconfident","Overwhelmed","Overwhelming","Paces","Pacifistic",
		"Painstaking","Pampered","Panicked","Panicky","Paranoid","Participating","Particular","Passionate","Passive",
		"Passive-aggressive","Pathetic","Patient","Patriotic","Peaceful","Penitent","Pensive","Perceptive","Perfect",
		"Perfectionist","Performer","Persecuted","Perserverant","Perseveres","Persevering","Persistent","Personable","Persuasive",
		"Pert","Perverse","Perverted","Pessimistic","Petrified","Petty","Petulant","Philanthropic","Picky","Pious","Pitiful","Pity",
		"Placid","Playful","Pleasant","Pleased","Pleasing","Plotting","Plucky","Polished","Polite","Pompous","Poor",
		"Poor communicator","Poor listener","Positive","Possessive","Power-hungry","Practical","Precise","Predictable","Preoccupied",
		"Pressured","Presumptuous","Pretentious","Pretty","Prim","Primitive","Private","Productive","Profane","Professional demeanor",
		"Promiscuous","Proper","Prosaic","Prosperous","Protective","Proud","Prudent","Psychotic","Puckish","Punctilious","Punctual",
		"Purposeful","Pushy","Puzzled","Quarrelsome","Queer","Quick","Quick tempered","Quiet","Quirky","Quitter","Quixotic","Radical",
		"Raging","Rambunctious","Random","Rash","Rational","Rawboned","Reactionary","Realistic","Reasonable","Reasoning","Rebellious",
		"Recalcitrant","Receptive","Reckless","Reclusive","Refined","Reflective","Refreshed","Regretful","Rejected","Rejects change",
		"Relaxed","Relentless","Relents","Reliable","Relieved","Religious","Reluctant","Remorseful","Remote","Repugnant","Repulsive",
		"Resentful","Reserved","Resilient","Resolute","Resourceful","Respectful","Respects experience","Respects traditional ideas",
		"Responsible","Responsive","Restless","Restrained","Results-oriented","Retiring","Reverent","Rewarded","Rhetorical","Right",
		"Righteous","Rigid","Risk averse","Risk-taking","Robust and healthy","Rogue","Romantic","Rough","Rowdy","Rude","Rule-bound",
		"Rule-conscious","Ruthless","Sacrificing","Sad","Sadistic","Safe","Sagely","Saintly","Salient","Sanctimonious","Sanguine",
		"Sarcastic","Sassy","Satisfied","Saucy","Savage","Savvy","Scared","Scarred","Scary","Scattered","Scheming","Scornful","Scrawny",
		"Screwed up","Scruffy","Secretive","Secure","Sedate","Seditious","Seductive","Sees the big picture","Selective","Self-absorbed",
		"Self-assured","Self-blaming","Self-centered","Self-confident","Self-conscious","Self-controlling","Self-deprecating",
		"Self-directed","Self-disciplined","Self-doubting","Self-effacing","Self-giving","Self-indulgent","Self-made","Self-reliant",
		"Self-righteous","Self-satisfied","Self-serving","Self-sufficient","Selfish","Selfless","Senile","Sense of duty","Sensitive",
		"Sensual","Sentimental","Serene","Serious","Servile","Settled","Sexual","Sexy","Shallow","Shameless","Sharp","Sharp-tongued",
		"Sharp-witted","Sheepish","Shiftless","Shifty","Shocked","Short-tempered","Shows initiative","Shrewd","Shy","Silent","Silky",
		"Silly","Simple","Simple-minded","Sincere","Sisterly","Skeptical","Skillful","Sleazy","Sloppy","Slovenly","Slow paced",
		"Sluggish","Slutty","Sly","Small-minded","Smart","Smiling","Smooth","Sneaky","Snob","Snobbish","Sociable","Socially bold",
		"Socially precise","Soft","Soft-hearted","Soft-spoken","Solemn","Solitary","Solution-oriented","Sophisticated","Sore",
		"Sorrowful","Sorry","Sour","Spendthrift","Spiritual","Spiteful","Splendid","Spoiled","Spontaneous","Sports fan","Spunky",
		"Squeamish","Staid","Startled","Stately","Static","Steadfast","Steady","Stern","Stimulating","Stingy","Stoic","Stoical",
		"Stolid","Straight laced","Straight-laced","Straightforward","Strange","Stress free","Stressed out","Strict","Strident",
		"Strong nerves","Strong willed","Stubborn","Studious","Stunned","Stupefied","Stupid","Suave","Submissive","Subtle","Successful",
		"Successful in school","Successful in work","Succinct","Suffering","Sulky","Sullen","Sultry","Supercilious","Superstitious",
		"Supportive","Sure","Surly","Suspicious","Suspicious of strangers","Sweet","Sycophantic","Sympathetic","Systematic","Taciturn",
		"Tacky","Tactful","Tactless","Takes responsibility","Talented","Talkative","Tardy","Tasteful","Telepathic","Temperamental",
		"Temperate","Tempted","Tenacious","Tender minded","Tense","Tentative","Tenuous","Terrible","Terrified","Testy","Thankful",
		"Thankless","Thick skinned","Thief","Thorough","Thoughtful","Thoughtless","Threatened","Threatening","Thrifty","Thrilled",
		"Thrillseeker","Thwarted","Tight","Time driven","Timid","Tired","Tireless","Tiresome","Toadying","Tolerant",
		"Tolerates disorder","Torpid","Touchy","Tough","Tough-minded","Traditional","Traitorous","Tranquil","Treacherous","Treasonous",
		"Tricky","Tries to do everything","Trivial","Troubled","Truculent","Trusting","Trustworthy","Truthful","Typical","Tyrannical",
		"Unappreciative","Unapproachable","Unassuming","Unaware of own limitations","Unbending","Unbiased","Uncaring","Uncommitted",
		"Uncommunicative","Unconcerned","Unconditional","Uncontrolled","Unconventional","Uncooperative","Uncoordinated","Uncouth",
		"Undependable","Understanding","Undesirable","Undisciplined","Uneasy","Uneducated","Unenthusiastic","Unexacting","Unfeeling",
		"Unfocused","Unforgiving","Unfriendly","Ungrateful","Unhappy","Unhelpful","Uninhibited","Unkind","Unlucky","Unmotivated",
		"Unpredictable","Unprejudiced","Unpretentious","Unreasonable","Unreceptive","Unreliable","Unresponsive","Unrestrained",
		"Unruly","Unscrupulous","Unselfish","Unsentimental","Unsettled","Unshakeable","Unsure","Unsuspecting","Unsuspicious",
		"Unsympathetic","Unsystematic","Unusual","Unwilling","Unworried","Upbeat","Upset","Uptight","Useful","Utilitarian","Vacant",
		"Vague","Vain","Valiant","Valorous","Values fair competition","Values family","Values hard work","Values honesty",
		"Values material possessions","Values money","Values religion","Vehement","Vengeful","Venomous","Venturesome","Verbose",
		"Versatile","Vicious","Vigilant","Vigorous","Vindictive","Violent","Virtuous","Visual","Vital","Vivacious","Volatile",
		"Voracious","Vulgar","Vulnerable","Wanton","Warlike","Warm","Warm hearted","Wary","Wasteful","Watchful","Weak","Weak nerves",
		"Weary","Weepy","Weird","Welcoming","Well grounded","Whimsical","Wholesome","Wicked","Wild","Willful","Willing","Willpower",
		"Wise","Wishy washy","Withdrawn","Witty","Wonderful","Works well under pressure","Worldly","Worried","Worrying","Worshipful",
		"Worships the devil","Worthless","Wretched","Xenophobic","Youthful","Zany","Zealot","Zealous","Sterile","Possessed","Psychopath"}
--traitsTable[''] = 


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local RandGenUtil = {Instances={}}
--local RandGenUtil = {}
local RandGenUtil_mt = { __index = RandGenUtil }  -- metatable
-- RandGenUtil.__index = RandGenUtil

function RandGenUtil:new(...)	-- constructor
	--local self = setmetatable( {}, RandGenUtil )
	local instance = setmetatable({}, self)
	--print ("CampaignList.new called, value="..init)
	--instance:initialize(...)
	return instance
end
 

function RandGenUtil:initialize()
	-- instance.cList = {}
	print ("RandGenUtil:initialize() - Initializing RandGenUtil...")
	table.insert(self.Instances, self)
	-- self.currentCampaignIndex = -1
	-- self.cList = {}
end

function RandGenUtil.__call(_, value)
	return Underscore:new(value)
end

function RandGenUtil:new(value, chained)
	return setmetatable({ _val = value or false }, self)
end

function foo()
	return "random foo"
end




function RandGenUtil.generateMaleName(self)
    numSyllables = math.random( 3 )
	print("gen'ing name, numSyllables=" .. numSyllables+1)

	local tmpName = "";
	for i = 1, numSyllables+1 do
		rarity = math.random(100)
		if rarity > 90 then
			tmpName = tmpName .. rarerSyllables[math.random(#rarerSyllables)]	
		else
			tmpName = tmpName .. syllables[math.random(#syllables)]	
		end
	end
		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  name generated: " .. tmpName)

	return tmpName
end

function RandGenUtil.generateTieflingSuffixName(self)
	local tieflingAttributes = {"hide", "horn", "horns", "eyes", "skin", "claws", "storm", "ire", "wrath", "tail", "tempest", "roar", "stalk", "howl",
	"squall", "thunder", "burn"}
	local nameType = math.random(3)
	local name = ""

	if nameType == 1 then
		return colorNames[math.random(#colorNames)] .. tieflingAttributes[math.random(#tieflingAttributes)]
	elseif nameType == 2 then
		adj = {"pointy", "sharp", "flat", "tall", "flaming", "stormy", "curled", "unfurled", "scarred", "chipped", "smooth", "rough", "majestic", 
			"barbed", "edged", "jagged", "peaked", "piercing", "fine", "honed", "needle", "briery", "prickle", "prong", "splinter", "spike", "taper"}
		noun = {"horns", "horn","knob", "point", "spike", "rack", "hook", "antlers"}
		name = adj[math.random(#adj)] .. noun[math.random(#noun)]
	else
		syls = 1 + math.random(2)
		for i=1, syls do
			name = name .. tieflingSuffixSurnames[math.random(#tieflingSuffixSurnames)]
		end
	end
		

	name = name:gsub("^%l", string.upper)
	return name

end

function RandGenUtil.generateNpcName(self, race)
	local name = ""
	if race then
		print("RandGenUtil.generateNpcName " .. race)
		if race == "Random" then
			race = RandGenUtil.generateNpcRace()
			print("RandGenUtil.generateNpcName " .. race)
		end
		if race == "dwarf" or race == "Dwarf" then
			name = dwarfMaleSyllables[math.random(#dwarfMaleSyllables)] .. dwarfMaleSyllables[math.random(#dwarfMaleSyllables)]
		elseif race == "elf" or race == "Elf" then
			syls = 1 + math.random(3)
			for i=1, syls do
				name = name .. elfMaleSyllables[math.random(#elfMaleSyllables)]
			end
		elseif race == "gnome" or race == "Gnome" then
			syls = 1 + math.random(3)
			for i=1, syls do
				name = name .. gnomeMaleSyllables[math.random(#gnomeMaleSyllables)]
			end
		elseif race == "half-orc" or race == "Half-Orc" then
			syls = 1 + math.random(3)
			for i=1, syls do
				name = name .. halforcMaleSyllables[math.random(#halforcMaleSyllables)]
			end
		elseif race == "halfling" or race == "Halfling" then
			syls = 1 + math.random(2)
			for i=1, syls do
				name = name .. halflingMaleSyllables[math.random(#halflingMaleSyllables)]
			end
		elseif race == "dragonborn" or race == "Dragonborn" then
			syls = 1 + math.random(2)
			for i=1, syls do
				name = name .. dragonbornMaleSyllables[math.random(#dragonbornMaleSyllables)]
			end
			
		elseif race == "tiefling" or race == "Tiefling" then
			local nameType = math.random(4)
			if nameType == 1 then
				-- Tiefling Virtue name
				name = tieflingVirtues[math.random(#tieflingVirtues)]
			else 
				syls = 1 + math.random(2)
				name = ""
				for i=1, syls do
					name = name .. tieflingMaleSyllables[math.random(#tieflingMaleSyllables)]
				end
				
				if nameType == 2 then
					-- Full Tiefling name
					local suffixName = RandGenUtil.generateTieflingSuffixName()
					suffixName = suffixName:gsub("^%l", string.upper)
					name = name .. " " .. suffixName
				end
			end
		else
			name = RandGenUtil:generateMaleName()
		end
	end	
	--Uppercase it
	name = name:gsub("^%l", string.upper)
	return name	
end

function RandGenUtil.generateTitleSuffix(self)
	return "of " .. RandGenUtil.generateMaleName()
end

function RandGenUtil.generateTitle(race)
	print("RandGenUtil.generateTitle() race=" .. tostring(race))
	local titles = {"Baron", "Baronness", "Count", "Countess", "Duchess", "Duke", "Earl", "King", "Lady", "Lord", "Madam", "Prince", 
					"Princess", "Queen", "Sir"}
	local dwarfTitles = {"King", "Thane", "Forgemaster", "Oathkeeper", "Axehead", "Hammerhead", "Clanhead", "Gemcutter"}
	local elfTitles = {"King", "Queen", "Forestlord", "Warden", "Grovekeeper", "Avatar"}
	if race == "Dwarf" or race == "dwarf" then
		return dwarfTitles[math.random(#dwarfTitles)]
	elseif race == "Elf" or race == "elf" then
		return elfTitles[math.random(#elfTitles)]
	end

	return titles[math.random(#titles)]
end

function RandGenUtil.generateClass()
	return classes[math.random(#classes)]
end

function RandGenUtil.generateNpcNameOption(self, npcBackground, npcRace)
	print("Generating Name Options for type: " .. tostring(npcBackground) .. " (" .. npcRace .. ")")
	if npcBackground == "Noble" then
		return RandGenUtil.generateTitle(npcRace)
	elseif npcBackground == "Merchant" then
		return RandGenUtil.generateTitleSuffix()
	elseif npcBackground == "Adventurer" then
		return RandGenUtil.generateClass()
	elseif npcBackground == "Commoner" then
		return ""
	end

	rarity = math.random(100)
	if rarity < 10 then
		return RandGenUtil.generateMaleName()
	elseif rarity < 50 then
		return RandGenUtil.generateTitle(npcRace)
	else
		return RandGenUtil.generateTitleSuffix()
	end
end



function RandGenUtil.getRandomTrait()
	local tmp_traits = ""

	ttl = tablelength(traitsTable)

	local i = 1
	
	tindex = math.random(ttl)
	print("Getting Random Trait from Traits Table. index is " .. tindex)

	for k,v in pairs(traitsTable) do
		if i == tindex then
			return traitsTable[k][math.random(#traitsTable[k])]
		else 
			i = i+1
		end
	end
end

function RandGenUtil.generateNpc(self)
	print("RGU:generateNpc(): generating NPC")
	race = RandGenUtil.generateNpcRace()
	print("RGU:generateNpc(): generating " .. race .. " details")
	npc = Npc:new(RandGenUtil:generateNpcName(race), race, RandGenUtil:generateNpcTraits(race))
	return npc
end

function RandGenUtil.generateNpcRace()
	return races[math.random(#races)]
end


function RandGenUtil.generateNpcTraits()
	local tmp_traits = ""

	--print("rando = " .. RandGenUtil.getRandomTrait() )
	ttl = tablelength(traitsTable)
	print("Getting Traits from Traits Table.  Possible trait count is " .. ttl)

	local i = 0

	local joiner = ""
	local tmp = ""
	for k,v in pairs(traitsTable) do
		if math.random(100) > 75 then
			tmp = traitsTable[k][math.random(#traitsTable[k])]
			print("  trait: " .. k .. ", choice: " .. tmp)
		else
			tmp = ""
		end

		if tmp ~= "" then
			if i > 0 then 
				joiner = ", " 
			else
				i=i+1
			end
			tmp_traits = tmp_traits .. joiner .. tmp
		end
	end

	if i == 0 then
		tmp_traits = RandGenUtil.getRandomTrait()
		print("  ** rando: " .. tmp_traits)
	end
	print( "  traits generated: " .. tmp_traits)

	return tmp_traits
end

function RandGenUtil.generateTownPopulation(self)
	return "Population: " .. tostring(math.random(100)*10)
end

function RandGenUtil.generateTownRuler(self)
	rulerProps = {"a gentle mayor", "committee", "a circle of elders", "a cruel dictator"} 
	return "Ruled by " .. rulerProps[math.random( #rulerProps )]
end

function RandGenUtil.generateLakeCharacteristic(self)
	local lakeProps = {"deep", "cold", "good fishing", "fed by stream", "dammed", "shallow", "warm", "good beaches"}
	return lakeProps[math.random( #lakeProps )]
end

function RandGenUtil.generateCryptCharacteristic(self)
	local lakeProps = {"currently uninhabited", "cold", "full of cobwebs", "collapsing", "glows eerily", "dark", "strange noises", "deeply silent"}
	return lakeProps[math.random( #lakeProps )]
end

function RandGenUtil.generateDungeonCharacteristic(self)
	local lakeProps = {"currently uninhabited", "cold", "full of cobwebs", "collapsing", "glows eerily", "dark", 
		"strange noises", "deeply silent", "flooded", "full of goblins", "full of orcs", "full of kobolds", "mazelike",
		"dusty"}
	return lakeProps[math.random( #lakeProps )]
end

function RandGenUtil.generateForestCharacteristic(self)
	local forestProps = {"strange things happen here at night", "cold", "full of cobwebs", "trees are diseased", "glows eerily", "dark", 
		"strange noises", "deeply silent", "flooded", "full of goblins", "full of orcs", "full of kobolds", "mazelike undergrowth",
		"feels like you are being watched all the time", "lacking animals", "wolf howling can be heard"}
	return forestProps[math.random( #forestProps )]
end

function RandGenUtil.generateSeaCharacteristic(self)
	local seaProps = {"deep", "cold", "good fishing", "dangerous reefs", "dangerous waves", "odd color", "warm", "good beaches", 
		"pirates roam the seas", "many harbours", "dangerous beasts lurk under the waves", "many shipwrecks", "tempestuous", "many islands"}
	return seaProps[math.random( #seaProps )]
end
function RandGenUtil.generateKeepCharacteristic(self)
	local dukeProps = {"Strongly fortified", "Ruled by Duke Smythe", "Large central tower", "high walls", "abandoned", 
		"decrepit", "many banners flying from walls", "deep dungeon underneath", "surrounded by moat", 
		"surrounded by difficult obstacles", "houses a garrison", "destroyed by a dragon", "destroyed long ago", 
		"recently captured", "busy with merchants", "stout"}
	return dukeProps[math.random( #dukeProps )]
end

function RandGenUtil:generateRoadCharacteristic(self) 
	local roadProps = {"dusty", "Bandits patrol the road.", "muddy", "dangerous at night", "patrolled by guards", "many bridges",
		"long and steep", "long and straight", "windy", "paved with cobblestones", "mountainous pass", "well travelled", "in disrepair"}
	return roadProps[math.random( #roadProps )]
end

function RandGenUtil:generateRegionCharacteristic(self) 
	local regionProps = { "arid", "tropical", "many lakes", "forested", "mountainous", "hilly", "many rivers", "abandoned", 
	"wasteland", "scorched", "dangerous", "rich with ore", "farmland", "dangerous ruler", "full of strange magic"} 
	return regionProps[math.random( #regionProps)]
end



function RandGenUtil.generatePlaceType()
	return placeTypes[math.random(#placeTypes)]
end


function RandGenUtil.generatePlaceNotes(self, plType)
	if plType == "Town" then
		return RandGenUtil:generateTownPopulation() .. ". " .. RandGenUtil:generateTownRuler()
	elseif plType == "Lake" then
		return RandGenUtil:generateLakeCharacteristic() .. ", " .. RandGenUtil:generateLakeCharacteristic() .. "."
	elseif plType == "Crypt" then
		return RandGenUtil:generateCryptCharacteristic()
	elseif plType == "Dungeon" then
		return RandGenUtil:generateDungeonCharacteristic() .. ", " .. RandGenUtil:generateDungeonCharacteristic() .. "."
	elseif plType == "Keep" then
		return RandGenUtil:generateKeepCharacteristic() 
	elseif plType == "Forest" then
		return RandGenUtil:generateForestCharacteristic() .. ", " .. RandGenUtil:generateForestCharacteristic() .. "."
	elseif plType == "Sea" then
		return RandGenUtil:generateSeaCharacteristic()
	elseif plType == "Road" then
		return RandGenUtil:generateRoadCharacteristic()
	elseif plType == "Region" then	
		return RandGenUtil:generateRegionCharacteristic()
	else
		return "other notes"
	end
end

function RandGenUtil.generatePlaceName(self, plType)
	local tmpName = "";

	if not plType then 
		print("RandGenUtil.generatePlaceName(): generating place type first.")
		plType = RandGenUtil.generatePlaceType() 
	end
	print("RGU.generatePlaceName() called, place type=" .. plType)

	

	local nameStyle =  math.random( 4 )
	local nameOrder = math.random( 2 )
	local placeName = ""

	if plType == "Lake" then
		placeName = lakeNames[math.random(#lakeNames)]
	elseif plType == "Crypt" then
		placeName = cryptNames[math.random(#cryptNames)]
	elseif plType == "Town" then
		placeName = townNames[math.random(#townNames)]
	elseif plType == "Dungeon" then
		placeName = dungeonNames[math.random(#dungeonNames)]
	elseif plType == "Keep" then
		placeName = keepNames[math.random(#keepNames)]
	elseif plType == "Forest" then
		placeName = forestNames[math.random(#forestNames)]
	elseif plType == "Sea" then
		placeName = seaNames[math.random(#seaNames)]
	elseif plType == "Road" then
		placeName = roadNames[math.random(#roadNames)]
	elseif plType == "Region" then
		placeName = regionNames[math.random(#regionNames)]
	end
	placeName = placeName:gsub("^%l", string.upper)

	if (nameStyle == 1) then -- Ariedor type name
		print("gen'ing Ariedor type name")

		if (nameOrder == 1) then
			tmpName = RandGenUtil:generateNpcName("Human") .. " " .. placeName
		else
			tmpName = placeName .. " " .. RandGenUtil:generateNpcName("Human")
		end			
	elseif (nameStyle == 2) then -- Blue Hills type name...
		print("gen'ing Blue Hills type name")
		cName = colorNames[math.random(#colorNames)]
		cName = cName:gsub("^%l", string.upper)
		if (nameOrder == 1) then
			tmpName = cName .. " " .. placeName
		else
			tmpName = placeName	.. " of " .. cName
		end
    elseif (nameStyle == 3) then -- Dusty Crypt type name...
    	print("gen'ing Dusty Crypt type name")
		
		tmpName = adjectives[math.random(#adjectives)] .. " " .. placeName
		tmpName = tmpName:gsub("^%l", string.upper)

	else -- Agdon Fort type name
		print("gen'ing Agdon Fort type type name")
		local randNameTmp = RandGenUtil:generateNpcName("Human")
		randNameTmp = randNameTmp:gsub("^%l", string.upper)
		if (nameOrder == 1) then
			tmpName = randNameTmp .. " " .. placeName
		else
			tmpName = placeName .. " of " .. randNameTmp
		end
	end

	print("  place name generated: " .. tmpName)

	return tmpName
end

function RandGenUtil.generatePlace(self, plType)
	if not plType or plType == "" then
		print("generatePlace(): generating place type first")
		plType = RandGenUtil.generatePlaceType()
	end
	newPlace = Place.new(RandGenUtil:generatePlaceName(plType), plType, RandGenUtil:generatePlaceNotes(plType))
	return newPlace
end

function RandGenUtil.generateTransportableThing(self)
	thingType = RandGenUtil:generateThingType()
	thing = Thing.new(RandGenUtil:generateThingName(thingType), thingType, RandGenUtil:generateThingNotes(thingType))
	return thing.name
end
function RandGenUtil.generateThing(self, type)
	thingType = type or RandGenUtil:generateThingType()
	thing = Thing.new(RandGenUtil:generateThingName(thingType), thingType, RandGenUtil:generateThingNotes(thingType))
	return thing
end

function RandGenUtil.generateThingType(self)
	local thingTypes = {"weapon", "armor", "potion", "wonderous item", "herb", "treasure", "common item", "magic item"}
	return thingTypes[math.random(#thingTypes)]
end

function RandGenUtil.generateEncounterType(self)
	local encounterTypes = {"surprise", "combatants", "puzzle"}
	return encounterTypes[math.random(#encounterTypes)]
end

function RandGenUtil.generateEncounter(self, type)
	encounterType = type or RandGenUtil:generateEncounterType()
	encounter = Encounter.new(RandGenUtil:generateEncounterName(encounterType), encounterType, RandGenUtil:generateEncounterNotes(encounterType))
	return encounter
end

function RandGenUtil.generateEncounterNotes(self, encounterType)
	local encounterNotesArr = {""}
	if encounterType == "surprise" then
		encounterNotesArr = {"ambush", "trap", "out of place", "unexpected"}
	elseif encounterType == "combatants" then
		encounterNotesArr = {"armored", "strong leader", "fast", "well equipped"}
	elseif encounterType == "puzzle" then
		encounterNotesArr = {"dusty", "ancient", "large-scale", "mysterious"}
	end

	return encounterNotesArr[math.random(#encounterNotesArr)]
end


function RandGenUtil.generateThingNotes(self, thingType) 
	local thingNotesArr = {""}
	if thingType == "weapon" then
		thingNotesArr = {"rusty", "silver", "sharp", "jeweled"}
	elseif thingType == "armor" then
		thingNotesArr = {"rusty", "silver", "light", "jeweled"}
	elseif thingType == "potion" then
		thingNotesArr = {"oily", "in a fancy bottle", "sweet", "sour"}
	elseif thingType == "wonderous item" then
		thingNotesArr = {"golden", "silver", "shiny", "jeweled"}
	elseif thingType == "herb" then
		thingNotesArr = {"wilted", "vibrant", "dried", "rare"}
	elseif thingType == "treasure" then
		thingNotesArr = {"golden", "silver", "shiny", "jeweled"}
	elseif thingType == "common item" then
		thingNotesArr = {"dusty", "oily", "well-made", "sturdy"}
	elseif thingType == "magic item" then
		thingNotesArr = {"golden", "silver", "shiny", "jeweled"}
	end

	return thingNotesArr[math.random(#thingNotesArr)]
end

function RandGenUtil.generateEncounterName(self, encounterType) 
	local tmpName = encounterType;	

		
	--tmpName = tmpName:gsub("^%l", string.upper)
	print("  encounter generated: " .. tmpName)
	
	return tmpName
end


function RandGenUtil.generateThingName(self, thingType) 
	local tmpName = "";


	if thingType == "weapon" then
		tmpName = thingNamesWeapon[math.random(#thingNamesWeapon)]
	elseif thingType == "armor" then
		tmpName = thingNamesArmor[math.random(#thingNamesArmor)]
	elseif thingType == "potion" then
		tmpName = thingNamesPotion[math.random(#thingNamesPotion)]
	elseif thingType == "wonderous item" then
		tmpName = thingNamesWondrous[math.random(#thingNamesWondrous)]
	elseif thingType == "herb" then
		tmpName = thingNamesHerb[math.random(#thingNamesHerb)]
	elseif thingType == "treasure" then
		tmpName = thingNamesTreasure[math.random(#thingNamesTreasure)]
	elseif thingType == "common item" then
		tmpName = thingNamesCommon[math.random(#thingNamesCommon)]
	elseif thingType == "magic item" then
		tmpName = thingNamesMagic[math.random(#thingNamesMagic)]
	end

	--tmpName = thingNames[math.random(#thingNames)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  thing generated: " .. tmpName)
	
	return tmpName
end


function RandGenUtil.generateAdversary( ) 
	local tmpName = "";

	tmpName = adversaries[math.random(#adversaries)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  adversary generated: " .. tmpName)
	
	return tmpName
end


buildables = {{"boat", "sail to", RandGenUtil.generatePlaceName}, 
			  {"cart", "transport", RandGenUtil.generateTransportableThing }, 
			  {"wagon", "travel to", RandGenUtil.generatePlaceName}, 
			  {"defenses", "defend", RandGenUtil.generatePlaceName, RandGenUtil.generateAdversary},
			  {"tunnel", "escape from", RandGenUtil.generatePlaceName, RandGenUtil.generateAdversary},
			  {"distraction", "divert", RandGenUtil.generateAdversary, RandGenUtil.generatePlaceName},
			  {"hiding spot", "spy on", RandGenUtil.generateAdversary, RandGenUtil.generatePlaceName},
			 }
function RandGenUtil.newBuildable(self)
    local self = {type = math.random(#buildables)}
    
   	local getAction = function () 
   		return buildables[self.type][2] or "A"
   	end

	local getType = function () 
		return buildables[self.type][1] or "T"
	end

	local getActionObjects = function()
		actionObjects = " "
		if buildables[self.type][3] then
			if type(buildables[self.type][3]) == 'function' then
				print("action object is a function, buildable is " .. buildables[self.type][1])
				actionObjects = actionObjects .. buildables[self.type][3]()
			else
				print("action object is a " .. type(buildables[self.type][3]))
			end
		end

		if buildables[self.type][4] then
			if type(buildables[self.type][4]) == 'function' then
				print("action object is a function")
				actionObjects = actionObjects .. " from " .. buildables[self.type][4]()
			else
				print("action object is a " .. type(buildables[self.type][4]))
			end
		end

		return actionObjects
	end

	return {
		getType = getType,
		getAction = getAction,
		getActionObjects = getActionObjects
	}
end

summonables = {{"dragon", "defend", RandGenUtil.generatePlaceName}, 
			  {"servant", "transport", RandGenUtil.generateTransportableThing }, 
			  {"imp", "spy on", RandGenUtil.generateAdversary, RandGenUtil.generatePlaceName},
			  {"protective barrier", "defend", RandGenUtil.generatePlaceName, RandGenUtil.generateAdversary},
			  {"tunnel", "escape from", RandGenUtil.generatePlaceName, RandGenUtil.generateAdversary},
			  {"distraction", "divert", RandGenUtil.generateAdversary, RandGenUtil.generatePlaceName},
			  {"spirit", "learn about", RandGenUtil.generateAdversary, RandGenUtil.generatePlaceName},
			 }
function RandGenUtil.newSummonable(self)
    local self = {type = math.random(#summonables)}
    
   	local getAction = function () 
   		return summonables[self.type][2] or "A"
   	end

	local getType = function () 
		return summonables[self.type][1] or "T"
	end

	local getActionObjects = function()
		actionObjects = " "
		if summonables[self.type][3] then
			if type(summonables[self.type][3]) == 'function' then
				print("action object is a function")
				actionObjects = actionObjects .. summonables[self.type][3]()
			else
				print("action object is a " .. type(summonables[self.type][3]))
			end
		end

		if summonables[self.type][4] then
			if type(summonables[self.type][4]) == 'function' then
				print("action object is a function")
				actionObjects = actionObjects .. " from " .. summonables[self.type][4]()
			else
				print("action object is a " .. type(summonables[self.type][4]))
			end
		end

		return actionObjects
	end

	return {
		getType = getType,
		getAction = getAction,
		getActionObjects = getActionObjects
	}
end

function RandGenUtil.generateQuestTrickType()
	tricks = {"trick", "gambit", "deception", "lie", "ploy", "ruse", "scheme", "maneuver", "contrivance", "machination", "wile", "deceit"}
	return tricks[math.random(#tricks)] 
end

function RandGenUtil.generateQuestTrick(questGiver, trickType)
	trickReasons = {"away from the area", "into a trap", "towards peril", "towards their enemy", "into conflict with another faction", 
					"into a situation they will be framed for", "to a gruesome discovery", "to a source of false information", "towards something they fear",
					"toward aquiring a cursed item", "into believing an ally has betrayed them", "on a wild goose chase", "into releasing a demon",
					"into questioning their faith", "into abandoning their quest", "into being imprisoned", "to another plane", "to a dangerous place",
					"into handing over an important item", "into performing a task", "into a dangerous forest", "into dangerous mountains", 
					"into becoming stranded on a deserted island", "into dispatching a rival", "into betraying an ally", "into doubting themselves",
					"across a dangerous sea", "into a dangerous cavern", "into a devilish labrynth", "to drinking poison", "into gambling something of great value",
					"into becoming outlaws", "into dooming a small town", "into destroying a powerful relic", "into retrieving a powerful relic", "into an icy wasteland",
					"into a dangerous volcano", "into becoming lost in the wilderness", "into battling a powerful diety", "into a social faux pas", 
					"into conflict with a dangerous ruler", "into a dangerous war zone", "to an isolated location", "to a dangerous dungeon"
				}
	return (questGiver .. " has devised a " .. trickType .. " to lure the party " .. trickReasons[math.random(#trickReasons)] .. ".")
end

function RandGenUtil.generateObstacle( ) 
	local tmpName = "";

	tmpName = obstacles[math.random(#obstacles)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  obstacle generated: " .. tmpName)
	
	return tmpName
end

function RandGenUtil.generateQuestType( )
	return math.random( 12 )
end

function RandGenUtil.generateFactionName()
	factionList = {"Moons", "Hands", "Enclave", "Knights", "Guild", "Circle", "Council", "Keepers", "Alliance", "Dragons", "Serpents", "Suns", "Stars", 
				   "Worlds", "Protectors", "Guards", "Clan", "Lions", "Scars", "Society"}
	factionMods = {"Thieves", "Council of", "Ring of", "Circle of", "Oath", "Blood", "Order of", "Lords of", "Dogs of", "War", "Battle", "Hawk", "Lion", 
				   "Seers of", "Wizards", "Sorcerers", "Paladins", "Crusaders"}
	fName = ""
	fnType = math.random(4)
	if fnType == 1 then
		fName = adjectives[math.random(#adjectives)]
	elseif fnType == 2 then
		fName = colorNames[math.random(#colorNames)]
	elseif fnType == 3 then
		fName = factionMods[math.random(#factionMods)]
	else
		fName = "The"
	end
	fName = fName:gsub("^%l", string.upper)

	return fName .. " " .. factionList[math.random(#factionList)] .. " Faction"
end

function generateRaceOrFaction()
	if math.random(2) == 1 then
		return RandGenUtil.generateNpcRace() .. "s"
	else
		return RandGenUtil.generateFactionName()
	end
end

function generatePeople()
	if math.random(2) == 1 then
		return RandGenUtil.generateNpcRace() .. "s"
	else
		return "people of " .. RandGenUtil.generatePlaceName()
	end
end

function generateOutlawableThing()
	things = {"magic", "trade", "music", "poetry", "alcohol", "commerce", "speech"}
	return things[math.random(#things)]
end

function RandGenUtil.generateFactionQuestType()
	factionQuestTypes = {{"warring with", generateRaceOrFaction},
						 {"subjugating", generatePeople},
						 {"enslaving", generatePeople},
						 {"scheming against", RandGenUtil.generateFactionName },
						 {"recruiting", RandGenUtil.generateAdversary},
						 {"outlawing", generateOutlawableThing},
						 {"trading unfairly", ""}}
	randomType = math.random(#factionQuestTypes)
	--print("FAction quest type is " .. factionQuestTypes[randomType][1])
	factionQuestType = factionQuestTypes[randomType][1]
	if type(factionQuestTypes[randomType][2]) == 'function' then
		factionQuestType = factionQuestType .. " " .. factionQuestTypes[randomType][2]()
	end

	return factionQuestType
end

function RandGenUtil.generateFactionQuest(faction, factionQuestType)
	return (faction .. " is " .. factionQuestType)
end

function RandGenUtil.generateDiscoveryMethod()
	methods={"found", "heard rumor of", "discovered", "found a clue to", "overheard", "read in a tome", "deduced", "stumbled upon", "chanced upon",
	         "uncovered", "unearthed", "detected", "determined"}
	return methods[math.random(#methods)]
end
function RandGenUtil.generateDiscovery()
	discoveries = {"valuable artwork", "an ancient tome", "a strange artifact", "treasure", "a strange portal", "a relic", "an abandoned temple", 
					"a mysterious keep", "a treasure hoard", "a mysterious tomb", "an abandoned tower", "a sunken treasure", "a hidden treasure", 
					"some long-forgotten knowledge"}
	return (discoveries[math.random(#discoveries)])
end

function RandGenUtil.generateRumorSubject()
	subjects = {"a strange magic", "an unlikely occurance nearby", "occult activity", "the dead rising", "ill omens", "a mysterious illness",
				"a large unidentified host", "a strange portal", "strange lights in the woods", "a foul stench", "a possible plague", "a dragon"}
	if (math.random(2) == 1) then
		return subjects[math.random(#subjects)]
	else
		return RandGenUtil.generateDiscovery()
	end
	
end

function RandGenUtil.generateQuest(self, qType)
	local qTmp = "";
	print("==========================================================")
	print("RandGenUtil.generateQuest() called")
	local newQuest = Quest.new("New Quest", "")

	local questStyle =  math.random( 12 )
	if qType ~= nil then
		questStyle = qType
	end
	local placeType = Randomizer:generatePlaceType()

	newQuest:addQuestGiver( RandGenUtil:generateNpc().name )

	print("RandGenUtil.generateQuest() quest type is " .. tostring(questStyle))
	if (questStyle == 1) then -- Gather: X has asked you to go to Y to retrieve Z
		local thing = RandGenUtil:generateThingName(Randomizer:generateThingType())
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to go to "
		qTmp = qTmp .. RandGenUtil:generatePlaceName(placeType) .. " to retrieve his "
		qTmp = qTmp .. thing
		newQuest:setName(newQuest.questGiver .. "'s " .. thing)
	elseif (questStyle == 2) then -- Investigate: X has done/is doing Y at Z
		local place = RandGenUtil:generatePlaceName(placeType)
		local adversary = RandGenUtil:generateAdversary()
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to go to "
		qTmp = qTmp .. place .. " to investigate "
		qTmp = qTmp .. adversary -- TODO: add more investigation topics
		newQuest:setName( adversary .. " of " .. place)
	elseif (questStyle == 3) then -- Kill: 
		local adversary = RandGenUtil:generateAdversary()
		local place = RandGenUtil:generatePlaceName(placeType)
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to go to "
		qTmp = qTmp .. place .. " to kill "
		qTmp = qTmp .. adversary
		newQuest:setName( "Kill " .. adversary .. " of " .. place)
	elseif (questStyle == 4) then -- Deliver: 
		local thing = RandGenUtil:generateThingName(Randomizer:generateThingType())
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to bring his "
		qTmp = qTmp .. thing .. " to " .. RandGenUtil:generateNpc().name
		qTmp = qTmp .. " in " .. RandGenUtil:generatePlaceName(placeType)
		newQuest:setName( thing .. " delivery")
	elseif (questStyle == 5) then -- Escort: 
		local name = RandGenUtil:generateNpc().name
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to escort "
		qTmp = qTmp .. name .. " to " 
		qTmp = qTmp .. RandGenUtil:generatePlaceName(placeType)
		newQuest:setName( name .. " escort")
	elseif (questStyle == 6) then -- Liberate:
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to save "
		place = RandGenUtil:generatePlaceName("Town")
		qTmp = qTmp .. place .. " from "
		qTmp = qTmp .. RandGenUtil:generateAdversary()
		newQuest:setName( "Save " .. place)
	elseif (questStyle == 7) then -- Summon/Build: 
		if (math.random(2) == 1) then
			buildable = RandGenUtil:newBuildable()
			newQuest:setName( "Build " .. buildable.getType())
			qTmp = qTmp .. newQuest.questGiver .. " has asked you to build a " .. buildable.getType() .. " to " .. buildable.getAction() .. buildable.getActionObjects()
		else
			summonable  = RandGenUtil:newSummonable()
			newQuest:setName( "Summon " .. summonable.getType())
			qTmp = qTmp .. newQuest.questGiver .. " has asked you to summon a " .. summonable.getType() .. " to " .. summonable.getAction() .. summonable.getActionObjects()
		end
	elseif (questStyle == 8) then -- Prophesy: 
		prophesies = {{"have a ", "dream"}, {"have a ", "premonition"}, {"witness an ", "omen"}, {"hear a ", "prophesy"}, 
					  {"recall a ", "legend"}, {"recall a ", "myth"}}
		adversary = RandGenUtil.generateAdversary()
		local i = math.random(#prophesies)
		newQuest:setName( prophesies[i][2] .. " of " .. adversary)
		qTmp = qTmp .. "You " .. prophesies[i][1] .. prophesies[i][2] .. " about " .. adversary .. " of " .. RandGenUtil.generatePlaceName()
	elseif (questStyle == 9) then -- Trick
		trickType = RandGenUtil.generateQuestTrickType()
		qTmp = RandGenUtil.generateQuestTrick(newQuest.questGiver, trickType)
		newQuest:setName(newQuest.questGiver .. "'s " .. trickType)
	elseif (questStyle == 10) then -- Faction Action
		factionQuestType = RandGenUtil.generateFactionQuestType()
		faction = RandGenUtil.generateFactionName()
		qTmp = RandGenUtil.generateFactionQuest(faction, factionQuestType)
		newQuest:setName(faction .. "'s " .. factionQuestType)
		--qTmp = "Faction A is warring/subjugating/enslaving/scheming against Faction B"
	elseif (questStyle == 11) then -- Discovery
		discoveryMethod = RandGenUtil.generateDiscoveryMethod()
		discovery = RandGenUtil.generateDiscovery()
		newQuest:setName(discovery .. " " .. discoveryMethod)
		qTmp = "the party has " .. discoveryMethod .. " information leading to the location of " .. discovery
	elseif (questStyle == 12) then -- Rumor
		rumorSubject = RandGenUtil.generateRumorSubject()
		qTmp = "Rumors abound about " .. rumorSubject
		newQuest:setName(rumorSubject .. " Rumor")
	end

	newQuest:setDescription(qTmp)
	newQuest:setDetails( RandGenUtil.generateQuestDetails(newQuest) )
	print ("RandGenUtil.generateQuest - Random Quest Generated: " .. qTmp)
	return newQuest

end

function RandGenUtil.genPrepPhrase()

	local prep = math.random ( 3 )

	if (prep == 1) then
		prepPhrase = "On the way is"
	elseif (prep == 2) then
		prepPhrase = "On the way back is"
	elseif (prep == 3) then
		prepPhrase = "Guarding it is"
	end

	return prepPhrase
end

function RandGenUtil.generateQuestDetails( quest)
	local qTmp = "";

	local questDetailsCount =  math.random( 3 )
	local prepPhrase = ""

	for i=1, questDetailsCount do
		local wrinkleType =  math.random( 3 )
		local prepPhrase = RandGenUtil.genPrepPhrase()

		if (wrinkleType == 1) then -- Obstacle:
			while ( prepPhrase == "Guarding it is") do
				prepPhrase = RandGenUtil.genPrepPhrase()
			end
			qTmp = qTmp .. "Wrinkle: " .. prepPhrase .. " " .. RandGenUtil:generateObstacle() .. "\n"
		elseif (wrinkleType == 2) then -- Monster: 
			qTmp = qTmp .. "Wrinkle: " .. prepPhrase .. " " .. RandGenUtil:generateAdversary() .. "\n"
		elseif (wrinkleType == 3) then -- Prerequisite: 
			qTmp = qTmp .. "Wrinkle: First you must find " .. quest.questGiver .. "'s"
			qTmp = qTmp .. "    " .. RandGenUtil:generateThingName(Randomizer:generateThingType()) .. "\n"
		end
	end
	
	print ("RandGenUtil.generateQuest - Random Quest Details Generated: " .. qTmp)
	return qTmp
end


function RandGenUtil.generateReward(self, rType, level)
	local reward = "";
	print("==========================================================")
	print("RandGenUtil.generateReward() called")
	
	if rType ~= nil then
		rewardType = rType
	else
		rewardType = math.random(2)
	end
	
	print("RandGenUtil.generateReward() reward type is " .. tostring(rewardType))
	print("RandGenUtil.generateReward() level is " .. tostring(level))
	
		if (rewardType == 1) then -- Individual
			reward = RandGenUtil:generateIndividualReward(level)
		elseif (rewardType == 2) then -- Hoard
			reward = RandGenUtil:generateHoardReward(level)
		end

	
	print ("RandGenUtil.generateReward - Random Reward Generated: " .. reward)
	return reward

end

function roll(num, die)
	print("rolling " .. num .. "d" .. die)
	res = 0
	for i=1, num do
		res = res + math.random(die)
	end
	return res
end


function rollMagicItemTableA(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 51 then
			items = items .. ", Potion of Healing"
		elseif d100 < 61 then
			items = items .. ", Spell scroll (cantrip)"
		elseif d100 < 71 then
			items = items .. ", Potion of Climbing"
		elseif d100 < 91 then
			items = items .. ", Spell Scroll (1st Level)"
		elseif d100 < 95 then
			items = items .. ", Spell Scroll (2nd Level)"
		elseif d100 < 99 then
			items = items .. ", Potion of Greater Healing"
		elseif d100 < 100 then
			items = items .. ", Bag of Holding"
		else
			items = items .. ", Driftglobe"
		end		
	end
	return items
end

function rollMagicItemTableB(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 16 then
			items = items .. ", Potion of Greater Healing"
		elseif d100 < 23 then
			items = items .. ", Potion of Fire Breath"
		elseif d100 < 30 then
			items = items .. ", Potion of Resistance"
		elseif d100 < 35 then
			items = items .. ", Ammunition +1"
		elseif d100 < 40 then
			items = items .. ", Potion of Animal Friendship"
		elseif d100 < 45 then
			items = items .. ", Potion of Hill Giant Strength"
		elseif d100 < 50 then
			items = items .. ", Potion of Growth"
		elseif d100 < 55 then
			items = items .. ", Potion of Water Breathing"
		elseif d100 < 60 then
			items = items .. ", Spell scroll (2nd level)"
		elseif d100 < 65 then	
			items = items .. ", Spell scroll (3rd level)"
		elseif d100 < 68 then		
			items = items .. ", Bag of Holding"
		elseif d100 < 71 then	
			items = items .. ", Keoghtom's ointment"
		elseif d100 < 74 then
			items = items .. ", Oil of slipperiness"
		elseif d100 < 76 then	
			items = items .. ", Dust of disappearance"
		elseif d100 < 78 then		
			items = items .. ", Dust of dryness"
		elseif d100 < 80 then	
			items = items .. ", Dust of sneezing and choking"
		elseif d100 < 82 then
			items = items .. ", Elemental gem"
		elseif d100 < 84 then	
			items = items .. ", Philter of love"
		elseif d100 < 85 then		
			items = items .. ", Alchemy jug"
		elseif d100 < 86 then	
			items = items .. ", Cap of water breathing"
		elseif d100 < 87 then
			items = items .. ", Cloak of the Manta Ray"
		elseif d100 < 88 then	
			items = items .. ", Driftglobe"
		elseif d100 < 89 then		
			items = items .. ", Goggles of night"
		elseif d100 < 90 then
			items = items .. ", Helm of comprehending languages"
		elseif d100 < 91 then	
			items = items .. ", Immovable rod"
		elseif d100 < 92 then	
			items = items .. ", Lantern of revealing"
		elseif d100 < 93 then	
			items = items .. ", Mariner's armor"
		elseif d100 < 94 then	
			items = items .. ", Mithral armor"
		elseif d100 < 95 then	
			items = items .. ", Potion of poison"
		elseif d100 < 96 then	
			items = items .. ", Ring of swimming"
		elseif d100 < 97 then	
			items = items .. ", Robe of useful items"
		elseif d100 < 98 then	
			items = items .. ", Rope of climbing"
		elseif d100 < 99 then	
			items = items .. ", Saddle of the cavalier"
		elseif d100 < 100 then	
			items = items .. ", Wand of magic detection"		
		else
			items = items .. ", Wand of secrets"
		end		
	end
	return items
end

function rollMagicItemTableC(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 16 then
			items = items .. ", Potion of Superior Healing"
		elseif d100 < 23 then
			items = items .. ", Spell scroll (4th level)"
		elseif d100 < 28 then
			items = items .. ", Ammunition +2"
		elseif d100 < 33 then
			items = items .. ", Potion of clairvoyance"
		elseif d100 < 38 then
			items = items .. ", Potion of diminution"
		elseif d100 < 43 then
			items = items .. ", Potion of gaseous form"
		elseif d100 < 48 then
			items = items .. ", Potion of frost giant strength"
		elseif d100 < 53 then
			items = items .. ", Potion of stone giant strength"
		elseif d100 < 58 then
			items = items .. ", Potion of heroism"
		elseif d100 < 63 then
			items = items .. ", Potion of invulnerability"
		elseif d100 < 68 then
			items = items .. ", Potion of mind reading"
		elseif d100 < 73 then
			items = items .. ", Spell scroll (5th level)"
		elseif d100 < 76 then
			items = items .. ", Elixir of health"
		elseif d100 < 79 then
			items = items .. ", Oil of etherealness"
		elseif d100 < 82 then
			items = items .. ", Potion of fire giant strength"
		elseif d100 < 85 then
			items = items .. ", Quaal's feather token"
		elseif d100 < 88 then
			items = items .. ", Scroll of protection"
		elseif d100 < 90 then
			items = items .. ", Bag of beans"
		elseif d100 < 92 then
			items = items .. ", Bead of force"
		elseif d100 < 93 then
			items = items .. ", Chime of opening"
		elseif d100 < 94 then
			items = items .. ", Decanter of endless water"
		elseif d100 < 95 then
			items = items .. ", Eyes of minute seeing"
		elseif d100 < 96 then
			items = items .. ", Folding boat"
		elseif d100 < 97 then
			items = items .. ", Heward's handy haversack"
		elseif d100 < 98 then
			items = items .. ", Horseshoes of speed"
		elseif d100 < 99 then
			items = items .. ", Necklace of fireballs"
		elseif d100 < 100 then
			items = items .. ", Periapt of health"
		else
			items = items .. ", Sending Stones"
		end		
	end
	return items
end

function rollMagicItemTableD(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 21 then
			items = items .. ", Potion of Supreme Healing"
		elseif d100 < 31 then
			items = items .. ", Potion of invisibility"
		elseif d100 < 41 then
			items = items .. ", Potion of Speed"
		elseif d100 < 51 then
			items = items .. ", Spell Scroll (6st Level)"
		elseif d100 < 58 then
			items = items .. ", Spell Scroll (7nd Level)"
		elseif d100 < 63 then
			items = items .. ", Ammunition +3"
		elseif d100 < 68 then
			items = items .. ", Oil of Sharpness"
		elseif d100 < 73 then
			items = items .. ", Potion of flying"
		elseif d100 < 78 then
			items = items .. ", Potion of cloud giant strength"
		elseif d100 < 83 then
			items = items .. ", Potion of longevity"
		elseif d100 < 88 then
			items = items .. ", Potion of vitality"
		elseif d100 < 93 then
			items = items .. ", Spell scroll (8thlevel)"
		elseif d100 < 96 then
			items = items .. ", Horseshoes of a zephyr"
		elseif d100 < 99 then
			items = items .. ", Nolzur's marvelous pigments"
		elseif d100 < 100 then
			items = items .. ", Bag of devouring"
		else
			items = items .. ", Portable hole"
		end		
	end
	return items
end

function rollMagicItemTableE(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 31 then
			items = items .. ", Spell scroll (8th level)"
		elseif d100 < 56 then
			items = items .. ", Potion of storm giant strength"
		elseif d100 < 71 then
			items = items .. ", Potion of supreme healing"
		elseif d100 < 86 then
			items = items .. ", Spell Scroll (9th Level)"
		elseif d100 < 94 then
			items = items .. ", Universal solvent"
		elseif d100 < 99 then
			items = items .. ", Arrow of slaying"
		else
			items = items .. ", Sovereign glue"
		end
	end
	return items
end

function rollMagicItemTableF(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 16 then
			items = items .. ", Weapon, +1"
		elseif d100 < 19 then
			items = items .. ", Shield,+ 1"
		elseif d100 < 22 then
			items = items .. ", Sentinel Shield"
		elseif d100 < 24 then
			items = items .. ", Amulet of proof against detection and location"
		elseif d100 < 26 then
			items = items .. ", Boots of elvenkind"
		elseif d100 < 28 then
			items = items .. ", Boots of striding and springing"
		elseif d100 < 30 then	
			items = items .. ", Bracers of archery"
		elseif d100 < 32 then
			items = items .. ", Brooch of shielding"
		elseif d100 < 34 then	
			items = items .. ", Broom of flying"
		elseif d100 < 36 then	
			items = items .. ", Cloak of elvenkind"
		elseif d100 < 38 then
			items = items .. ", Cloak of protection"
		elseif d100 < 40 then	
			items = items .. ", Gauntlets of ogre power"
		elseif d100 < 42 then	
			items = items .. ", Hat of disguise"
		elseif d100 < 44 then
			items = items .. ", Javelin of lightning"
		elseif d100 < 46 then	
			items = items .. ", Pearl of power"
		elseif d100 < 48 then	
			items = items .. ", Rod of the pact keeper, + 1"
		elseif d100 < 50 then
			items = items .. ", Slippers of spider climbing"
		elseif d100 < 52 then	
			items = items .. ", Staff of the adder"
		elseif d100 < 54 then	
			items = items .. ", Staff of the python"
		elseif d100 < 56 then
			items = items .. ", Sword of vengeance"
		elseif d100 < 58 then		
			items = items .. ", Trident of fish command"
		elseif d100 < 60 then	
			items = items .. ", Wand of magic missiles"
		elseif d100 < 62 then
			items = items .. ", Wand of the war mage, + 1"
		elseif d100 < 64 then		
			items = items .. ", Wand of web"
		elseif d100 < 66 then	
			items = items .. ", Weapon of warning"
		elseif d100 < 67 then
			items = items .. ", Adamantine armor (chain mail)"
		elseif d100 < 68 then		
			items = items .. ", Adamantine armor (chain shirt)"
		elseif d100 < 69 then	
			items = items .. ", Adamantine armor (scale mail)"
		elseif d100 < 70 then
			items = items .. ", Bag of tricks (gray)"
		elseif d100 < 71 then		
			items = items .. ", Bag of tricks (rust)"
		elseif d100 < 72 then	
			items = items .. ", Bag of tricks (tan)"
		elseif d100 < 73 then
			items = items .. ", Boots of the winterlands"
		elseif d100 < 74 then		
			items = items .. ", Circlet of blasting"
		elseif d100 < 75 then	
			items = items .. ", Deck of illusions"
		elseif d100 < 76 then
			items = items .. ", Eversmoking bottle"
		elseif d100 < 77 then		
			items = items .. ", Eyes of charming"
		elseif d100 < 78 then	
			items = items .. ", Eyes of the eagle"
		elseif d100 < 79 then
			items = items .. ", Figurine of wondrous power (silver raven)"
		elseif d100 < 80 then		
			items = items .. ", Gem of brightness"
		elseif d100 < 81 then	
			items = items .. ", Gloves of missile snaring"
		elseif d100 < 82 then
			items = items .. ", Gloves of swimming and climbing"
		elseif d100 < 83 then		
			items = items .. ", Gloves of thievery"
		elseif d100 < 84 then	
			items = items .. ", Headband of intellect"
		elseif d100 < 85 then
			items = items .. ", Helm of telepathy"
		elseif d100 < 86 then		
			items = items .. ", Instrument of the bards (Doss lute)"
		elseif d100 < 87 then	
			items = items .. ", Instrument of the bards (Fochlucan bandore)"
		elseif d100 < 88 then
			items = items .. ", Instrument of the bards (Mac-Fuimidh cittern)"
		elseif d100 < 89 then		
			items = items .. ", Medallion of thoughts"
		elseif d100 < 90 then	
			items = items .. ", Necklace of adaptation"
		elseif d100 < 91 then
			items = items .. ", Periapt of wound closure"
		elseif d100 < 92 then		
			items = items .. ", Pipes of haunting"
		elseif d100 < 93 then	
			items = items .. ", Pipes of the sewers"
		elseif d100 < 94 then
			items = items .. ", Ring of jumping"
		elseif d100 < 95 then		
			items = items .. ", Ring of mind shielding"
		elseif d100 < 96 then	
			items = items .. ", Ring of warmth"
		elseif d100 < 97 then
			items = items .. ", Ring of water walking"
		elseif d100 < 98 then		
			items = items .. ", Quiver of Ehlonna"
		elseif d100 < 99 then	
			items = items .. ", Stone of good luck"
		elseif d100 < 100 then
			items = items .. ", Wind fan"
		else
			items = items .. ", Winged boots"
		end
	end
	return items
end

function rollMagicItemTableG(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 12 then
			items = items .. ", Weapon, +2"
		elseif d100 < 15 then
			items = items .. ", Figurine of Wondrous Power ("
			local d8 = math.random(8)
			if (d8 == 1) then 
				items = items .. "Bronze Griffon)"
			elseif (d8 == 2) then 
				items = items .. "Ebony Fly)"
			elseif (d8 == 3) then 
				items = items .. "Golden Lions)"
			elseif (d8 == 4) then 
				items = items .. "Ivory Goats)"
			elseif (d8 == 5) then 
				items = items .. "Marble Elephant)"
			elseif (d8 < 8) then 
				items = items .. "Bronze Griffon)"
			else 
				items = items .. "Serpentine Owl)"
			end

		elseif d100 < 16 then
			items = items .. ", Adamantine armor (breastplate)"
		elseif d100 < 17 then
			items = items .. ", Adamantine armor (splint)"
		elseif d100 < 18 then
			items = items .. ", Amulet of health"
		elseif d100 < 19 then	
			items = items .. ", Armor of vulnerability"
		elseif d100 < 20 then
			items = items .. ", Arrow-catching shield"
		elseif d100 < 21 then	
			items = items .. ", Belt of dwarvenkind"
		elseif d100 < 22 then	
			items = items .. ", Belt of hill giant strength"
		elseif d100 < 23 then
			items = items .. ", Berserker axe"
		elseif d100 < 24 then	
			items = items .. ", Boots of levitation"
		elseif d100 < 25 then	
			items = items .. ", Boots of speed"
		elseif d100 < 26 then
			items = items .. ", Bowl of commanding water elementals"
		elseif d100 < 27 then	
			items = items .. ", Bracers of defense"
		elseif d100 < 28 then	
			items = items .. ", Brazier of commanding fire elementals"
		elseif d100 < 29 then
			items = items .. ", Cape of the mountebank"
		elseif d100 < 30 then	
			items = items .. ", Censer of controlling air elementals"
		elseif d100 < 31 then	
			items = items .. ", Armor, +1 chain mail"
		elseif d100 < 32 then
			items = items .. ", Armor of resistance (chain mail)"
		elseif d100 < 33 then		
			items = items .. ", Armor of resistance (chain shirt)"
		elseif d100 < 34 then	
			items = items .. ", Armor,+ 1 chain shirt"
		elseif d100 < 35 then	
			items = items .. ", Cloak of displacement"
		elseif d100 < 36 then
			items = items .. ", Cloak of the bat"
		elseif d100 < 37 then		
			items = items .. ", Cube of force"
		elseif d100 < 38 then	
			items = items .. ", Daern's instant fortress"
		elseif d100 < 39 then	
			items = items .. ", Dagger of venom"
		elseif d100 < 40 then	
			items = items .. ", Dimensional shackles"
		elseif d100 < 41 then	
			items = items .. ", Dragon slayer"
		elseif d100 < 42 then	
			items = items .. ", Elven chain"
		elseif d100 < 43 then	
			items = items .. ", Flame tongue"
		elseif d100 < 44 then	
			items = items .. ", Gem of seeing"
		elseif d100 < 45 then	
			items = items .. ", Giant slayer"
		elseif d100 < 46 then	
			items = items .. ", Clamoured studded leather"
		elseif d100 < 47 then	
			items = items .. ", Helm of teleportation"
		elseif d100 < 48 then	
			items = items .. ", Horn of blasting"
		elseif d100 < 49 then	
			items = items .. ", Horn of Valhalla (silver or brass)"
		elseif d100 < 50 then	
			items = items .. ", Instrument of the bards (Canaith mandolin)"
		elseif d100 < 51 then	
			items = items .. ", Instrument ofthe bards (Cii lyre)"
		elseif d100 < 52 then	
			items = items .. ", loun stone (awareness)"
		elseif d100 < 53 then	
			items = items .. ", loun stone (protection)"
		elseif d100 < 54 then	
			items = items .. ", loun stone (reserve)"
		elseif d100 < 55 then	
			items = items .. ", loun stone (sustenance)"
		elseif d100 < 56 then	
			items = items .. ", Iron bands of Bilarro"
		elseif d100 < 57 then	
			items = items .. ", Armor, + 1 leather"
		elseif d100 < 58 then	
			items = items .. ", Armor of resistance (leather)"
		elseif d100 < 59 then	
			items = items .. ", Mace of disruption"
		elseif d100 < 60 then	
			items = items .. ", Mace of smiting"
		elseif d100 < 61 then	
			items = items .. ", Mace of terror"
		elseif d100 < 62 then	
			items = items .. ", Mantle of spell resistance"
		elseif d100 < 63 then	
			items = items .. ", Necklace of prayer beads"
		elseif d100 < 64 then	
			items = items .. ", Periapt of proof against poison"
		elseif d100 < 65 then	
			items = items .. ", Ring of animal influence"
		elseif d100 < 66 then	
			items = items .. ", Ring of evasion"
		elseif d100 < 67 then
			items = items .. ", Ring of feather falling"
		elseif d100 < 68 then		
			items = items .. ", Ring of free action"
		elseif d100 < 69 then	
			items = items .. ", Ring of protection"
		elseif d100 < 70 then
			items = items .. ", Ring of resistance"
		elseif d100 < 71 then		
			items = items .. ", Ring of spell storing"
		elseif d100 < 72 then	
			items = items .. ", Ring of the ram"
		elseif d100 < 73 then
			items = items .. ", Ring of X-ray vision"
		elseif d100 < 74 then		
			items = items .. ", Robe of eyes"
		elseif d100 < 75 then	
			items = items .. ", Rod of rulership"
		elseif d100 < 76 then
			items = items .. ", Rod of the pact keeper, +2"
		elseif d100 < 77 then		
			items = items .. ", Rope of entanglement"
		elseif d100 < 78 then	
			items = items .. ", Armor, +1 scale mail"
		elseif d100 < 79 then
			items = items .. ", Armor of resistance (scale mail)"
		elseif d100 < 80 then		
			items = items .. ", Shield, +2"
		elseif d100 < 81 then	
			items = items .. ", Shield of missile attraction"
		elseif d100 < 82 then
			items = items .. ", Staff of charming"
		elseif d100 < 83 then		
			items = items .. ", Staff of healing"
		elseif d100 < 84 then	
			items = items .. ", Staff of swarming insects"
		elseif d100 < 85 then
			items = items .. ", Staff of the woodlands"
		elseif d100 < 86 then		
			items = items .. ", Staff of withering"
		elseif d100 < 87 then	
			items = items .. ", Stone of controlling earth elementals"
		elseif d100 < 88 then
			items = items .. ", Sun blade"
		elseif d100 < 89 then		
			items = items .. ", Sword of life stealing"
		elseif d100 < 90 then	
			items = items .. ", Sword of wounding"
		elseif d100 < 91 then
			items = items .. ", Tentacle rod"
		elseif d100 < 92 then		
			items = items .. ", Vicious weapon"
		elseif d100 < 93 then	
			items = items .. ", Wand of binding"
		elseif d100 < 94 then
			items = items .. ", Wand of enemy detection"
		elseif d100 < 95 then		
			items = items .. ", Wand of fear"
		elseif d100 < 96 then	
			items = items .. ", Wand of fireballs"
		elseif d100 < 97 then
			items = items .. ", Wand of lightning bolts"
		elseif d100 < 98 then		
			items = items .. ", Wand of paralysis"
		elseif d100 < 99 then	
			items = items .. ", Wand of the war mage, +2"
		elseif d100 < 100 then
			items = items .. ", Wand of wonder"
		else
			items = items .. ", Wings of flying"
		end
	end
	return items
end

function rollMagicItemTableH(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 11 then
			items = items .. ", Weapon, +3"
		elseif d100 < 13 then
			items = items .. ", Amulet of the planes"
		elseif d100 < 15 then
			items = items .. ", Carpet of flying"
		elseif d100 < 17 then
			items = items .. ", Crystal ball (very rare version)"
		elseif d100 < 19 then	
			items = items .. ", Ring of regeneration"
		elseif d100 < 21 then	
			items = items .. ", Ring of shooting stars"
		elseif d100 < 23 then
			items = items .. ", Ring of telekinesis"
		elseif d100 < 25 then	
			items = items .. ", Robe of scintillating colors"
		elseif d100 < 27 then	
			items = items .. ", Robe of stars"
		elseif d100 < 29 then
			items = items .. ", Rod of absorption"
		elseif d100 < 31 then	
			items = items .. ", Rod of alertness"
		elseif d100 < 33 then		
			items = items .. ", Rod of security"
		elseif d100 < 35 then	
			items = items .. ", Rod of the pact keeper, +3"
		elseif d100 < 37 then		
			items = items .. ", Scimitar of speed"
		elseif d100 < 39 then	
			items = items .. ", Shield, +3"
		elseif d100 < 41 then	
			items = items .. ", Staff of fire"
		elseif d100 < 43 then	
			items = items .. ", Staff of frost"
		elseif d100 < 45 then	
			items = items .. ", Staff of power"
		elseif d100 < 47 then	
			items = items .. ", Staff of striking"
		elseif d100 < 49 then	
			items = items .. ", Staff of thunder and lightning"
		elseif d100 < 51 then	
			items = items .. ", Sword of sharpness"
		elseif d100 < 53 then	
			items = items .. ", Wand of polymorph"
		elseif d100 < 55 then	
			items = items .. ", Wand of the war mage, + 3"
		elseif d100 < 56 then	
			items = items .. ", Adamantine armor (half plate)"
		elseif d100 < 57 then	
			items = items .. ", Adamantine armor (plate)"
		elseif d100 < 58 then	
			items = items .. ", Animated shield"
		elseif d100 < 59 then	
			items = items .. ", Belt of fire giant strength"
		elseif d100 < 60 then	
			items = items .. ", Belt of frost (or stone) giant strength"
		elseif d100 < 61 then	
			items = items .. ", Armor, + 1 breastplate"
		elseif d100 < 62 then	
			items = items .. ", Armor of resistance (breastplate)"
		elseif d100 < 63 then	
			items = items .. ", Candle of invocation"
		elseif d100 < 64 then	
			items = items .. ", Armor, +2 chain mail"
		elseif d100 < 65 then	
			items = items .. ", Armor, +2 chain shirt"
		elseif d100 < 66 then	
			items = items .. ", Cloak of arachnida"
		elseif d100 < 67 then
			items = items .. ", Dancing sword"
		elseif d100 < 68 then		
			items = items .. ", Demon armor"
		elseif d100 < 69 then	
			items = items .. ", Dragon scale mail"
		elseif d100 < 70 then
			items = items .. ", Dwarven plate"
		elseif d100 < 71 then		
			items = items .. ", Dwarven thrower"
		elseif d100 < 72 then	
			items = items .. ", Efreeti bottle"
		elseif d100 < 73 then
			items = items .. ", Figurine of wondrous power (obsidian steed)"
		elseif d100 < 74 then		
			items = items .. ", Frost brand"
		elseif d100 < 75 then	
			items = items .. ", Helm of brilliance"
		elseif d100 < 76 then
			items = items .. ", Horn of Valhalla (bronze)"
		elseif d100 < 77 then		
			items = items .. ", Instrument of the bards (Anstruth harp)"
		elseif d100 < 78 then	
			items = items .. ", loun stone (absorption)"
		elseif d100 < 79 then
			items = items .. ", loun stone (agility)"
		elseif d100 < 80 then		
			items = items .. ", loun stone (fortitude)"
		elseif d100 < 81 then	
			items = items .. ", loun stone (insight)"
		elseif d100 < 82 then
			items = items .. ", loun stone (intellect)"
		elseif d100 < 83 then		
			items = items .. ", loun stone (leadership)"
		elseif d100 < 84 then	
			items = items .. ", loun stone (strength)"
		elseif d100 < 85 then
			items = items .. ", Armor, +2 leather"
		elseif d100 < 86 then		
			items = items .. ", Manual of bodily health"
		elseif d100 < 87 then	
			items = items .. ", Manual of gainful exercise"
		elseif d100 < 88 then
			items = items .. ", Manual of golems"
		elseif d100 < 89 then		
			items = items .. ", Manual of quickness of action"
		elseif d100 < 90 then	
			items = items .. ", Mirror of life trapping"
		elseif d100 < 91 then
			items = items .. ", Nine lives stealer"
		elseif d100 < 92 then		
			items = items .. ", Oathbow"
		elseif d100 < 93 then	
			items = items .. ", Armor, +2 scale mail"
		elseif d100 < 94 then
			items = items .. ", Spellguard shield"
		elseif d100 < 95 then		
			items = items .. ", Armor, + 1 splint"
		elseif d100 < 96 then	
			items = items .. ", Armor of resistance (splint)"
		elseif d100 < 97 then
			items = items .. ", Armor, + 1 studded leather"
		elseif d100 < 98 then		
			items = items .. ", Armor of resistance (studded leather)"
		elseif d100 < 99 then	
			items = items .. ", Tome of clear thought"
		elseif d100 < 100 then
			items = items .. ", Tome of leadership and influence"
		else
			items = items .. ", Tome of understanding"
		end
	end
	return items
end


function rollMagicItemTableI(numRolls)
	local items = ""
	for i=1,numRolls do
		local d100 = math.random(100)
		if d100 < 6 then
			items = items .. ", Defender"
		elseif d100 < 11 then
			items = items .. ", Hammer of thunderbolts"
		elseif d100 < 16 then
			items = items .. ", Luck Blade"
		elseif d100 < 21 then
			items = items .. ", Sword of answering"
		elseif d100 < 24 then	
			items = items .. ", Holy avenger"
		elseif d100 < 27 then	
			items = items .. ", Ring of djinni summoning"
		elseif d100 < 30 then
			items = items .. ", Ring of invisibility"
		elseif d100 < 33 then		
			items = items .. ", Ring of spell turning"
		elseif d100 < 39 then	
			items = items .. ", Rod of lordly might"
		elseif d100 < 42 then	
			items = items .. ", Vorpal sword"
		elseif d100 < 44 then	
			items = items .. ", Belt of cloud giant strength"
		elseif d100 < 46 then	
			items = items .. ", Armor, +2 breastplate"
		elseif d100 < 48 then	
			items = items .. ", Armor, +3 chain mail"
		elseif d100 < 50 then	
			items = items .. ", Armor, +3 chain shirt"
		elseif d100 < 52 then	
			items = items .. ", Cloak of invisibility"
		elseif d100 < 54 then	
			items = items .. ", Crystal ball (legendary version)"
		elseif d100 < 56 then	
			items = items .. ", Armor, + 1 half plate"
		elseif d100 < 58 then	
			items = items .. ", Iron flask"
		elseif d100 < 60 then	
			items = items .. ", Armor, +3 leather"
		elseif d100 < 62 then	
			items = items .. ", Armor, +1 plate"
		elseif d100 < 64 then	
			items = items .. ", Robe of the archmagi"
		elseif d100 < 66 then	
			items = items .. ", Rod of resurrection"
		elseif d100 < 68 then		
			items = items .. ", Armor, +1 scale mail"
		elseif d100 < 70 then
			items = items .. ", Scarab of protection"
		elseif d100 < 72 then	
			items = items .. ", Armor, +2 splint"
		elseif d100 < 74 then		
			items = items .. ", Armor, +2 studded leather"
		elseif d100 < 76 then
			items = items .. ", Well of many worlds"
		elseif d100 < 77 then		
			local d12 = math.random(6)
			if d12 == 1 then
				items = items .. ", Half Plate +2"
			elseif d12 == 2 then
				items = items .. ", Platemail +2"
			elseif d12 == 3 then
				items = items .. ", Studded Leather +3"
			elseif d12 == 4 then
				items = items .. ", Breastplate +3"
			elseif d12 == 5 then
				items = items .. ", Splint mail +3"
			else
				if math.random(2) == 1 then
					items = items .. ", Half Plate +3"
				else
					items = items .. ", Plate Mail +3"
				end
			end
		elseif d100 < 78 then	
			items = items .. ", Apparatus of Kwalish"
		elseif d100 < 79 then
			items = items .. ", Armor of invulnerability"
		elseif d100 < 80 then		
			items = items .. ", Belt of storm giant strength"
		elseif d100 < 81 then	
			items = items .. ", Cubic gate"
		elseif d100 < 82 then
			items = items .. ", Deck of many things"
		elseif d100 < 83 then		
			items = items .. ", Efreeti chain"
		elseif d100 < 84 then	
			items = items .. ", Armor of resistance (half plate)"
		elseif d100 < 85 then
			items = items .. ", Horn of Valhalla (iron)"
		elseif d100 < 86 then		
			items = items .. ", Instrument of the bards (OIIamh harp)"
		elseif d100 < 87 then	
			items = items .. ", loun stone (greater absorption)"
		elseif d100 < 88 then
			items = items .. ", loun stone (mastery)"
		elseif d100 < 89 then		
			items = items .. ", loun stone (regeneration)"
		elseif d100 < 90 then	
			items = items .. ", Plate armor of etherealness"
		elseif d100 < 91 then
			items = items .. ", Plate armor of resistance"
		elseif d100 < 92 then		
			items = items .. ", Ring of air elemental command"
		elseif d100 < 93 then	
			items = items .. ", Ring of earth elemental command"
		elseif d100 < 94 then
			items = items .. ", Ring of fire elemental command"
		elseif d100 < 95 then		
			items = items .. ", Ring of three wishes"
		elseif d100 < 96 then	
			items = items .. ", Ring of water elemental command"
		elseif d100 < 97 then
			items = items .. ", Sphere of annihilation"
		elseif d100 < 98 then		
			items = items .. ", Talisman of pure good"
		elseif d100 < 99 then	
			items = items .. ", Talisman of the sphere"
		elseif d100 < 100 then
			items = items .. ", Talisman of ultimate evil"
		else
			items = items .. ", Tome of the stilled tongue"
		end
	end
	return items
end


function RandGenUtil.generateIndividualReward(self, level)
	print("RandGenUtil.generateReward() generating level " .. tostring(level) .. " Individual reward.")
	local reward = "";

	local d100 = math.random(100)
	print("RandGenUtil.generateReward() generating d100: " .. tostring(d100))
	if level < 5 then
		if d100 < 31 then
			reward = reward .. roll(5,6) .. " CP"
		elseif d100 < 61 then
			reward = reward .. roll(4,6) .. " SP"
		elseif d100 < 71 then
			reward = reward .. roll(3,6) .. " EP"
		elseif d100 < 96 then
			reward = reward .. roll(3,6) .. " GP"
		else
			reward = reward .. roll(1,6) .. " PP"
		end
	elseif level < 11 then
		if d100 < 31 then
			reward = reward .. roll(4,6) .. "00 CP"
			reward = reward .. ", " .. roll(1,6) .. "0 EP"
		elseif d100 < 61 then
			reward = reward .. roll(6,6) .. "00 SP"
			reward = reward .. ", " .. roll(2,6) .. "0 GP"
		elseif d100 < 71 then
			reward = reward .. roll(1,6) .. "00 EP"
			reward = reward .. ", " .. roll(2,6) .. "0 GP"
		elseif d100 < 96 then
			reward = reward .. roll(4,6) .. "0 GP"
		else
			reward = reward .. roll(2,6) .. "0 GP"
			reward = reward .. ", " .. roll(3,6) .. " PP"
		end 
	elseif level < 17 then
		if d100 < 21 then
			reward = reward .. roll(4,6) .. "00 SP"
			reward = reward .. ", " .. roll(1,6) .. "00 GP"
		elseif d100 < 36 then
			reward = reward .. roll(1,6) .. "00 EP"
			reward = reward .. ", " .. roll(1,6) .. "00 GP"
		elseif d100 < 76 then
			reward = reward .. roll(2,6) .. "00 GP"
			reward = reward .. ", " .. roll(1,6) .. "0 PP"
		else
			reward = reward .. roll(2,6) .. "00 GP"
			reward = reward .. ", " .. roll(2,6) .. "0 PP"
		end
	else
		if d100 < 16 then
			reward = reward .. roll(2,6) .. "000 EP"
			reward = reward .. ", " .. roll(8,6) .. "00 GP"
		elseif d100 < 56 then
			reward = reward .. roll(1,6) .. "000 GP"
			reward = reward .. ", " .. roll(1,6) .. "00 PP"
		else
			reward = reward .. roll(1,6) .. "000 GP"
			reward = reward .. ", " .. roll(2,6) .. "00 PP"
		end
	end
	return reward
end

function RandGenUtil.generateHoardReward(self, level)
	print("RandGenUtil.generateReward() generating level " .. tostring(level) .. " Hoard reward.")
	local reward = "";


	local d100 = math.random(100)
	print("RandGenUtil.generateReward() generating d100: " .. tostring(d100))
	if level < 5 then
		print("RandGenUtil.generateHoardReward(): generating coins")
		reward = roll(6,6) .. "00 CP"
		reward = reward .. ", " .. roll(3,6) .. "00 SP"
		reward = reward .. ", " .. roll(2,6) .. "0 GP"
		if d100 < 7 then
			reward = reward .. "."
		elseif d100 < 17 then
			reward = reward .. ", " .. roll(2,6) .. " 10 GP gems"
		elseif d100 < 27 then
			reward = reward .. ", " .. roll(2,4) .. " 25 GP art objects"
		elseif d100 < 37 then	
			reward = reward .. ", " .. roll(2,6) .. " 50 GP gems"
		elseif d100 < 45 then		
			reward = reward .. ", " .. roll(2,6) .. " 10 GP gems"
			reward = reward .. rollMagicItemTableA(math.random(6))
		elseif d100 < 53 then	
			reward = reward .. ", " .. roll(2,4) .. " 25 GP art objects"
			reward = reward .. rollMagicItemTableA(math.random(6))
		elseif d100 < 61 then	
			reward = reward .. ", " .. roll(2,6) .. " 50 GP gems"
			reward = reward .. rollMagicItemTableA(math.random(6))
		elseif d100 < 66 then		
			reward = reward .. ", " .. roll(2,6) .. " 10 GP gems"
			reward = reward .. rollMagicItemTableB(math.random(4))
		elseif d100 < 71 then	
			reward = reward .. ", " .. roll(2,4) .. " 25 GP art objects"
			reward = reward .. rollMagicItemTableB(math.random(4))
		elseif d100 < 76 then	
			reward = reward .. ", " .. roll(2,6) .. " 50 GP gems"
			reward = reward .. rollMagicItemTableB(math.random(4))
		elseif d100 < 79 then		
			reward = reward .. ", " .. roll(2,6) .. " 10 GP gems"
			reward = reward .. rollMagicItemTableC(math.random(4))
		elseif d100 < 81 then	
			reward = reward .. ", " .. roll(2,4) .. " 25 GP art objects"
			reward = reward .. rollMagicItemTableC(math.random(4))
		elseif d100 < 86 then	
			reward = reward .. ", " .. roll(2,6) .. " 50 GP gems"
			reward = reward .. rollMagicItemTableC(math.random(4))
		elseif d100 < 93 then	
			reward = reward .. ", " .. roll(2,4) .. " 25 GP art objects"
			reward = reward .. rollMagicItemTableF(math.random(4))
		elseif d100 < 98 then	
			reward = reward .. ", " .. roll(2,6) .. " 50 GP gems"
			reward = reward .. rollMagicItemTableF(math.random(4))
		elseif d100 < 100 then	
			reward = reward .. ", " .. roll(2,4) .. " 25 GP art objects"
			reward = reward .. rollMagicItemTableG(math.random(4))
		else	
			reward = reward .. ", " .. roll(2,6) .. " 50 GP gems"
			reward = reward .. rollMagicItemTableG(math.random(4))
		end
	elseif level < 11 then
		print("RandGenUtil.generateHoardReward(): generating coins")
		reward = roll(2,6) .. "00 CP"
		reward = reward .. ", " .. roll(2,6) .. "000 SP"
		reward = reward .. ", " .. roll(6,6) .. "00 GP"
		reward = reward .. ", " .. roll(3,6) .. "0 PP"
		
		print("RandGenUtil.generateHoardReward(): generating loot:")
		
		if d100 < 5 then
			print("no additional loot")
		elseif d100 < 11 then
			reward = reward .. ", " .. roll(2,4) .. " 25gp art objects"
		elseif d100 < 17 then
			reward = reward .. ", " .. roll(3,6) .. " 50 gp gems"
		elseif d100 < 23 then
			reward = reward .. ", " .. roll(3,6) .. " 100 gp gems"
		elseif d100 < 29 then
			reward = reward .. ", " .. roll(2,4) .. " 25 gp art objects"
		elseif d100 < 33 then
			reward = reward .. ", " .. roll(2,4) .. " 25 gp art objects"
			reward = reward .. rollMagicItemTableA(math.random(6))
		elseif d100 < 37 then
			reward = reward .. ", " .. roll(3,6) .. " 50 gp gems"
			reward = reward .. rollMagicItemTableA(math.random(6))
		elseif d100 < 41 then
			reward = reward .. ", " .. roll(3,6) .. " 100 gp gem"
			reward = reward .. rollMagicItemTableA(math.random(6))
		elseif d100 < 45 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableA(math.random(6))
		elseif d100 < 50 then
			reward = reward .. ", " .. roll(2,4) .. " 25 gp art objects"
			reward = reward .. rollMagicItemTableB(math.random(4))
		elseif d100 < 55 then
			reward = reward .. ", " .. roll(3,6) .. " 50 gp gem"
			reward = reward .. rollMagicItemTableB(math.random(4))
		elseif d100 < 60 then
			reward = reward .. ", " .. roll(3,6) .. " 100 gp gem"
			reward = reward .. rollMagicItemTableB(math.random(4))
		elseif d100 < 64 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableB(math.random(4))
		elseif d100 < 67 then
			reward = reward .. ", " .. roll(2,4) .. " 25 gp gem"
			reward = reward .. rollMagicItemTableC(math.random(4))
		elseif d100 < 70 then
			reward = reward .. ", " .. roll(3,6) .. " 50 gp gem"
			reward = reward .. rollMagicItemTableC(math.random(4))
		elseif d100 < 73 then
			reward = reward .. ", " .. roll(3,6) .. " 100 gp gem"
			reward = reward .. rollMagicItemTableC(math.random(4))
		elseif d100 < 75 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableC(math.random(4))
		elseif d100 < 77 then
			reward = reward .. ", " .. roll(2,4) .. " 25 gp art objects"
			reward = reward .. rollMagicItemTableD(1)
		elseif d100 < 79 then
			reward = reward .. ", " .. roll(3,6) .. " 50 gp gems"
			reward = reward .. rollMagicItemTableD(1)
		elseif d100 < 80 then
			reward = reward .. ", " .. roll(3,6) .. " 100 gp gems"
			reward = reward .. rollMagicItemTableD(1)
		elseif d100 < 81 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableD(1)
		elseif d100 < 85 then
			reward = reward .. ", " .. roll(2,4) .. " 25 gp art objects"
			reward = reward .. rollMagicItemTableF(math.random(4))
		elseif d100 < 89 then
			reward = reward .. ", " .. roll(3,6) .. " 50 gp gems"
			reward = reward .. rollMagicItemTableF(math.random(4))
		elseif d100 < 92 then
			reward = reward .. ", " .. roll(3,6) .. " 100 gp gems"
			reward = reward .. rollMagicItemTableF(math.random(4))
		elseif d100 < 95 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableF(math.random(4))
		elseif d100 < 97 then
			reward = reward .. ", " .. roll(3,6) .. " 100 gp gems"
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 99 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableG(math.random(6))
		elseif d100 < 100 then
			reward = reward .. ", " .. roll(3,6) .. " 100 gp gems"
			reward = reward .. rollMagicItemTableH(1)
		else
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableH(1)
		end
	elseif level < 17 then
		print("RandGenUtil.generateHoardReward(): generating coins")
		reward = roll(4,6) .. "000 GP"
		reward = reward .. ", " .. roll(5,6) .. "00 PP"
		print("RandGenUtil.generateHoardReward(): generating loot:")
		
		if d100 < 4 then
			print("no additional loot")
		elseif d100 < 7 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
		elseif d100 < 11 then
			reward = reward .. ", " .. roll(2,4) .. " 750 gp art objects"
		elseif d100 < 13 then
			reward = reward .. ", " .. roll(3,6) .. " 500 gp gems"
		elseif d100 < 16 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
		elseif d100 < 20 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableA(math.random(4))
			reward = reward .. rollMagicItemTableB(math.random(6))
		elseif d100 < 24 then
			reward = reward .. ", " .. roll(2,4) .. " 750 gp art objects"
			reward = reward .. rollMagicItemTableA(math.random(4))
			reward = reward .. rollMagicItemTableB(math.random(6))
		elseif d100 < 27 then
			reward = reward .. ", " .. roll(3,6) .. " 500 gp gems"
			reward = reward .. rollMagicItemTableA(math.random(4))
			reward = reward .. rollMagicItemTableB(math.random(6))
		elseif d100 < 30 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableA(math.random(4))
			reward = reward .. rollMagicItemTableB(math.random(6))
		elseif d100 < 36 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableC(math.random(6))
		elseif d100 < 41 then
			reward = reward .. ", " .. roll(2,4) .. " 750 gp art objects"
			reward = reward .. rollMagicItemTableC(math.random(6))
		elseif d100 < 46 then
			reward = reward .. ", " .. roll(3,6) .. " 500 gp gems"
			reward = reward .. rollMagicItemTableC(math.random(6))
		elseif d100 < 51 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableC(math.random(6))
		elseif d100 < 55 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableD(math.random(4))
		elseif d100 < 59 then
			reward = reward .. ", " .. roll(2,4) .. " 750 gp art objects"
			reward = reward .. rollMagicItemTableD(math.random(4))
		elseif d100 < 63 then
			reward = reward .. ", " .. roll(3,6) .. " 500 gp gems"
			reward = reward .. rollMagicItemTableD(math.random(4))
		elseif d100 < 67 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableD(math.random(4))
		elseif d100 < 69 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableE(1)
		elseif d100 < 71 then
			reward = reward .. ", " .. roll(2,4) .. " 750 gp art objects"
			reward = reward .. rollMagicItemTableE(1)
		elseif d100 < 73 then
			reward = reward .. ", " .. roll(3,6) .. " 500 gp gems"
			reward = reward .. rollMagicItemTableE(1)
		elseif d100 < 75 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableE(1)
		elseif d100 < 77 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableF(1)
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 79 then
			reward = reward .. ", " .. roll(2,4) .. " 750 gp art objects"
			reward = reward .. rollMagicItemTableF(1)
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 81 then
			reward = reward .. ", " .. roll(3,6) .. " 500 gp gems"
			reward = reward .. rollMagicItemTableF(1)
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 83 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableF(1)
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 86 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableH(math.random(4))
		elseif d100 < 89 then
			reward = reward .. ", " .. roll(2,4) .. " 750 gp art objects"
			reward = reward .. rollMagicItemTableH(math.random(4))
		elseif d100 < 91 then
			reward = reward .. ", " .. roll(3,6) .. " 500 gp gems"
			reward = reward .. rollMagicItemTableH(math.random(4))
		elseif d100 < 93 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableH(math.random(4))
		elseif d100 < 95 then
			reward = reward .. ", " .. roll(2,4) .. " 250 gp art objects"
			reward = reward .. rollMagicItemTableI(1)
		elseif d100 < 97 then
			reward = reward .. ", " .. roll(2,4) .. " 750 gp art objects"
			reward = reward .. rollMagicItemTableI(1)
		elseif d100 < 99 then
			reward = reward .. ", " .. roll(3,6) .. " 500 gp gems"
			reward = reward .. rollMagicItemTableI(1)
		else
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableI(1)
		end
	else
		print("RandGenUtil.generateHoardReward(): generating coins")
		reward = roll(12,6) .. "000 GP"
		reward = reward .. ", " .. roll(8,6) .. "000 PP"

		print("RandGenUtil.generateHoardReward(): generating loot:")
		if d100 < 3 then
			print("none")
		elseif d100 < 6 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableC(math.random(8))
		elseif d100 < 9 then
			reward = reward .. ", " .. roll(1,10) .. " 2500 gp art objects"
			reward = reward .. rollMagicItemTableC(math.random(8))
		elseif d100 < 12 then
			reward = reward .. ", " .. roll(1,4) .. " 7500 gp art objects"
			reward = reward .. rollMagicItemTableC(math.random(8))
		elseif d100 < 15 then
			reward = reward .. ", " .. roll(1,8) .. " 5000 gp gems"
			reward = reward .. rollMagicItemTableC(math.random(8))
		elseif d100 < 23 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableD(math.random(6))
		elseif d100 < 31 then
			reward = reward .. ", " .. roll(1,10) .. " 2500 gp art objects"
			reward = reward .. rollMagicItemTableD(math.random(6))
		elseif d100 < 39 then
			reward = reward .. ", " .. roll(1,4) .. " 7500 gp art objects"
			reward = reward .. rollMagicItemTableD(math.random(6))
		elseif d100 < 47 then
			reward = reward .. ", " .. roll(1,8) .. " 5000 gp gems"
			reward = reward .. rollMagicItemTableD(math.random(6))
		elseif d100 < 53 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableE(math.random(6))
		elseif d100 < 59 then
			reward = reward .. ", " .. roll(1,10) .. " 2500 gp art objects"
			reward = reward .. rollMagicItemTableE(math.random(6))
		elseif d100 < 64 then
			reward = reward .. ", " .. roll(1,4) .. " 7500 gp art objects"
			reward = reward .. rollMagicItemTableE(math.random(6))
		elseif d100 < 69 then
			reward = reward .. ", " .. roll(1,8) .. " 5000 gp gems"
			reward = reward .. rollMagicItemTableE(math.random(6))
		elseif d100 < 70 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 71 then
			reward = reward .. ", " .. roll(1,10) .. " 2500 gp art objects"
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 72 then
			reward = reward .. ", " .. roll(1,4) .. " 7500 gp art objects"
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 73 then
			reward = reward .. ", " .. roll(1,8) .. " 5000 gp gems"
			reward = reward .. rollMagicItemTableG(math.random(4))
		elseif d100 < 75 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableH(math.random(4))
		elseif d100 < 77 then
			reward = reward .. ", " .. roll(1,10) .. " 2500 gp art objects"
			reward = reward .. rollMagicItemTableH(math.random(4))
		elseif d100 < 79 then
			reward = reward .. ", " .. roll(1,4) .. " 7500 gp art objects"
			reward = reward .. rollMagicItemTableH(math.random(4))
		elseif d100 < 81 then
			reward = reward .. ", " .. roll(1,8) .. " 5000 gp gems"
			reward = reward .. rollMagicItemTableH(math.random(4))
		elseif d100 < 86 then
			reward = reward .. ", " .. roll(3,6) .. " 1000 gp gems"
			reward = reward .. rollMagicItemTableI(math.random(4))
		elseif d100 < 91 then
			reward = reward .. ", " .. roll(1,10) .. " 2500 gp art objects"
			reward = reward .. rollMagicItemTableI(math.random(4))
		elseif d100 < 96 then
			reward = reward .. ", " .. roll(1,4) .. " 7500 gp art objects"
			reward = reward .. rollMagicItemTableI(math.random(4))
		else
			reward = reward .. ", " .. roll(1,8) .. " 5000 gp gems"
			reward = reward .. rollMagicItemTableI(math.random(4))
		end
	end

	return reward
end


function RandGenUtil.generateEventTitle(self)
	return RandGenUtil.generateMaleName() .. " Goes to " .. RandGenUtil.generatePlaceName()
end

function RandGenUtil.generateEventNotes(self)
	return RandGenUtil.generateMaleName() .. " Goes to " .. RandGenUtil.generatePlaceName()
end
 -- Initialize the RandGenUtil
RandGenUtil:new()
RandGenUtil:initialize()


return RandGenUtil