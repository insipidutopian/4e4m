-- 
-- Abstract: RandGenUtil - Random Generation Utilities 
--  
-- Version: 1.0
-- 

local quest = require ( "quest" )

local syllables = { "a","al","ald","ale","an","and","ap","ar","bal","ban","bar","bert","bin","bon","cha","cid","con",
					"crys","dar","de","dor","e","ed","el","em","er","fer","foul","fred","ga","gar","gib","gir","god",
					"gra","gre","guet","ha","han","her","hu","i","ian","ias","if","in","ing","ip","is","jer","jo","jon",
					"kal","kin","kor","la","le","lo","lou","mich","mo","nar","ne","o","on","pha","raf","ram","ret","reu",
					"rex","ri","rick","rot","ryk","sa","toll","u","us","y" }
local rarerSyllables = { "fowk", "jab", "nais", "pho","pip","que","zi"}

local syllablesOld = { "an", "dor", "in", "al", "gar", "zi", "ip", "er", "ar", "el", "if", "ap", "nar",
			  	 	"jo", "jon", "dar", "raf", "cha", "le", "o", "lo", "ri", "a", "pip", "kal", "jab",
			   		"kor", "kal", "bin", "ban", "la", "gre", "gra", "pho", "pha", "cid" }


local adjectives = {"old", "forgotten", "iron", "golden", "pleasant", "dusty", "dark", "gloomy", "bright",
					"murky", "misty", "sullen", "wintry", "burned", "crumbling", "shadowy", "night" }
local colorNames = {"blue", "green", "white", "red", "black", "grey", "gold" }
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


local thingNames = {"sword", "bow", "dagger", "staff", "wand", "axe", "spear", "halberd", "glaive",
					"necklace", "treasure chest", "ring", "brooch", "crown", "gem", "bracelet", "gold",
					"torch", "daughter", "walking stick", "kettle", "knife", "knickers", "pantaloons", 
					"shield", "armor", "helmet", "helm", "buckler", "breastplate", "boots"}

local adversaries = {"orcs", "a dragon", "kobolds", "bandits", "mercenaries", "giants", "trolls",
					 "a rust monster", "minotaurs", "drow", "duergar"}

local obstacles = {"washed out road", "ruined bridge", "flooded river", "slaughtered caravan"}


local traits = {{"fat","chubby","obese","pot-bellied","gaunt","bean-pole","skinny","well-proportioned"}, 
				{"tall", "short"}, {"button-nose", "hawkish", "long nosed", "broad nosed", "slender nose"},
				{"clean shaven", "mustache", "beard", "goatee", "scruff", "stubble"}, 
				{"piercing eyes", "dead eyes" }, {"amiable", "gruff", "friendly", "stern"}}

local races = {"Human", "Gnome", "Elf", "Half-Elf", "Half-Orc", "Dwarf", "Dragonborn", "Tiefling", "Halfling"}
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
traitsTable['Mental'] = {"Abrasive","Abrupt","Absent-minded","Adamant","Adaptable","ADHD","Afraid","Afraid of commitment","Afraid of ghosts","Agonized","Alcoholic","Alert","Aloof","Always late","Ambitious","Analytical","Angry","Annoyed","Anti-intellectual","Anxious","Apathetic","Apprehensive","Arbitrary","Aristocratic","Art collector","Articulate","Artistic","Artless","Ashamed","Aspiring","Assertive","Astonished","Astounded","Astute","Attentive","Attentive to others","Audacious","Austere","Authoritarian","Authoritative","Autocratic","Avoids conflict","Aware of own limitations","Awed","Awful","Awkward","Babbling","Babyish","Backstabber","Bashful","Belligerent","Benevolent","Betrayed","Bewildered","Bewitching","Biter","Bitter","Blames others","Blas▒","Blissful","Blowhard","Boastful","Boisterous","Bold","Boorish","Bored","Boring","Bossy","Boundless","Bragging","Brainy","Brash","Bratty","Brave","Brazen","Bright","Brilliant","Broad-minded","Brotherly","Brutish","Bubbly","Bully","Burdened","Busy","Calculating","Callous","Calm","Candid","Capable","Capricious","Captivated","Carefree","Careful","Careless","Careless of social rules","Caring","Caustic","Cautious","Changeable","Charismatic","Charitable","Charming","Chaste","Chatty","Cheat","Cheerful","Cheerless","Childish","Chivalrous","Civilised","Classy","Clean","Clever","Close","Closed","Clumsy","Coarse","Cocky","Coherent","Cold","Cold hearted","Combative","Comfortable","Committed","Communicative","Compassionate","Competent","Competitive","Complacent","Compliant","Compulsive","Compulsive liar","Conceited","Concerned","Concrete thinking","Condemned","Condescending","Confident","Conformist","Confused","Congenial","Connoisseur of good drink","Connoisseur of good food","Conscientious","Conservative","Considerate","Consistent","Conspicuous","Conspiracy theorist","Constricting","Constructive","Content","Contented","Contrarian","Contrary","Contrite","Controlling","Conventional","Conversational","Cool","Cooperative","Coquettish","Cosmopolitan","Courageous","Courteous","Covetous","Cowardly","Cowering","Coy","Crabby","Crafty","Cranky","Crazy","Creative","Credible","Creepy","Critical","Cross","Crude","Cruel","Crushed","Cuddly","Culpable","Cultured","Cunning","Curious","Cutthroat","Cynical","Dainty","Dangerous","Daredevil","Daring","Dark","Dashing","Dauntless","Dazzling","Debonair","Deceitful","Deceiving","Decent","Decisive","Decorous","Dedicated","Defeated","Deferential","Defiant","Delegates authority","Deliberate","Deliberative","Delicate","Delighted","Delightful","Delusional about own skills","Demanding","Demonic","Dependable","Dependent","Depraved","Depressed","Depressive","Deranged","Desirous","Despairing","Despicable","Despondent","Destructive","Detached","Detail-oriented","Determined","Develops close friendships","Devilish","Devious","Devoted","Devout","Dictatorial","Diffident","Dignified","Diligent","Diminished","Diplomatic","Direct","Directionless","Disaffected","Disagreeable","Discerning","Disciplined","Discontented","Discouraged","Discreet","Disgusting","Dishonest","Disillusioned","Disinterested","Disloyal","Dismayed","Disorderly","Disorganized","Disparaging","Disregards rules","Disrespectful","Dissatisfied","Dissident","Dissolute","Distant","Distracted","Distraught","Distressed","Distrustful","Disturbed","Divided","Docile","Does what is convenient","Does what is necessary or right","Dogmatic","Dominant","Domineering","Dorky","Doubtful","Dowdy","Downtrodden","Draconian","Dramatic","Dreamer","Dreamy","Dreary","Driven","Dubious","Dull","Dumb","Dutiful","Dynamic","Eager","Easily embarrassed","Easily led","Easily upset","Easygoing","Eccentric","Ecstatic","Educated","Effervescent","Efficient","Egocentric","Egotistic","Egotistical","Elated","Electrified","Eloquent","Elusive","Embarrassed","Embittered","Embraces change","Eminent","Emotional","Emotionally stable","Empathetic","Empty","Enchanted","Enchanting","Encouraging","Enduring","Energetic","Engaging","Enigmatic","Enjoys a good argument","Enjoys a good brawl","Enjoys a little friendly competition","Enterprising","Entertaining","Enthusiastic","Entrepreneurial","Envious","Equable","Erratic","Ethical","Evasive","Evil","Exacting","Exasperated","Excellent","Excessive","Excitable","Excited","Exclusive","Exhausted","Expansive","Expedient","Experimental","Expert","Expressive","Extravagant","Extraverted","Extreme","Exuberant","Fabulous","Faces reality","Facetious","Faded","Failure","Fair","Faith in oneself","Faith in others","Faith in self","Faithful","Faithless","Fake","Fanatical","Fanciful","Fantastic","Fascinated","Fast learner","Fastidious","Fatalistic","Fatigued","Fawning","Fearful","Fearless","Feisty","Ferocious","Fidgety","Fierce","Fiery","Fine","Finicky","Fitness fanatic","Flagging","Flakey","Flamboyant","Flashy","Fleeting","Flexible","Flighty","Flippant","Flirtatious","Flirty","Flustered","Focused","Follower","Follows rules","Foolhardy","Foolish","Forceful","Forgetful","Forgiving","Formal","Forthright","Fortunate","Foul","Fragile","Fragmented","Frank","Frantic","Frazzled","Free of guilt","Free thinking","Fresh","Fretful","Friendly","Frightened","Frigid","Frugal","Frustrated","Fuddy duddy","Fun","Fun loving","Fun to be around","Funny","Furious","Furtive","Fussy","Gabby","Garrulous","Gaudy","Generous","Genial","Gentle","Genuine","Giddy","Giggly","Gives others their freedom","Gives up easily","Giving","Glad","Glamorous","Gloomy","Glorious","Glum","Glutton","Gluttonous","Goal orientated","Good","Good communicator","Good listener","Good-natured","Good-spirited","Goofy","Graceful","Gracious","Grandiose","Grateful","Gratified","Greedy","Gregarious","Grief","Grieving","Groovy","Grotesque","Grouchy","Grounded","Group-oriented","Growly","Gruesome","Gruff","Grumpy","Guarded","Guileless","Guilt prone","Guilt ridden","Guilty","Gullible","Haggard","Haggling","Handsome","Happy","Happy go lucky","Hard","Hard working","Harmonious","Harried","Harsh","Has clear goals","Hassled","Hateful","Haughty","Heartless","Heavenly","Heavy hearted","Hedonistic","Helpful","Helpless","Heroic","Hesitant","High","High energy","High self esteem","High social status","Hilarious","Hobbyist","Holy","Homeless","Homesick","Honest","Honor bound","Honorable","Hopeful","Hopeless","Horrible","Hospitable","Hostile","Hot headed","Huffy","Humble","Humorous","Hurt","Hypocritical","Hysterical","Ignorant","Ignored","Ill-bred","Imaginative","Immaculate","Immature","Immobile","Immodest","Impartial","Impatient","Impeccable","Imperial","Impersonal","Impolite","Impotent","Impoverished","Impractical","Impressed","Improves self","Impudent","Impulsive","In harmony","Inactive","Incoherent","Incompetent","Inconsiderate","Inconsistent","Indecisive","Independent","Indifferent","Indiscrete","Indiscriminate","Individualistic","Indolent","Indulgent","Industrious","Inefficient","Inept","Infantile","Infatuated","Inflexible","Informed","Infuriated","Inherited success","Inhibited","Inhumane","Inimitable","Innocent","Inquisitive","Insane","Insecure","Insensitive","Insightful","Insincere","Insipid","Insistent","Insolent","Insouciant","Inspired","Instinctive","Insulting","Intellectual","Intelligent","Intense","Interested","Interrupting","Intimidated","Intimidating","Intolerant","Intrepid","Introspective","Introverted","Intuitive","Inventive","Involved","Irresolute","Irresponsible","Irreverent","Irritable","Irritating","Isolated","Jackass","Jaded","Jealous","Jittery","Joking","Jolly","Jovial","Joyful","Joyous","Judgmental","Jumpy","Just","Keen","Kenderish","Kind","Kind hearted","Kittenish","Knowledgeable","Lackadaisical","Lacking","Laconic","Languid","Lascivious","Late","Lax","Lazy","Leader","Leaves things unfinished","Lecherous","Lethargic","Level","Lewd","Liar","Liberal","Licentious","Light-hearted","Likeable","Likes people","Limited","Lineat","Lingering","Lively","Logical","Lonely","Longing","Loquacious","Lordly","Loud","Loudmouth","Lovable","Love","Lovely","Lover, not a fighter","Loves challenge","Loving","Low confidence","Low drive","Low social status","Lowly","Loyal","Loyal to boss","Loyal to community","Loyal to family","Loyal to friends","Lucky","Lunatic","Lusty","Lying","Macho","Mad","Malevolent","Malice","Malicious","Maniacal","Manic","Manipulative","Mannered","Mannerly","Masochistic","Materialistic","Matronly","Matter-of-fact","Mature","Maudlin","Mean","Mean-spirited","Meek","Megalomaniac","Melancholy","Melodramatic","Mentally slow","Merciful","Mercurial","Messy","Meticulous","Mild","Mischievous","Miserable","Miserly","Mistrusting","Modern","Modest","Moody","Moping","Moralistic","Morbid","Motherly","Motivated","Muddled goals","Murderer","Mysterious","Mystical","Nagging","Naive","Narcissistic","Narrow-minded","Nasty","Natural leader","Naughty","Neat","Needs social approval","Needy","Negative","Negligent","Nervous","Neurotic","Never gives up","Never hungry","Nibbler","Nice","Night owl","Nihilistic","Nit picker","No purpose","No self confidence","No-nonsense","Noble","Noisy","Non-committing","Nonchalant","Nonconforming","Nostalgic","Nosy","Not trustworthy","Nuanced","Nuisance","Nurturing","Nut","Obedient","Obliging","Oblivious","Obnoxious","Obscene","Obsequious","Observant","Obsessed","Obsessive about something","Obstinate","Odd","Odious","Open","Open to change","Open-minded","Opinionated","Opportunistic","Oppositional","Optimistic","Orcish","Orderly","Organized","Ornery","Ossified","Ostentatious","Others can't be relied on","Outgoing","Outraged","Outrageous","Outspoken","Over wrought","Overbearing","Overconfident","Overwhelmed","Overwhelming","Paces","Pacifistic","Painstaking","Pampered","Panicked","Panicky","Paranoid","Participating","Particular","Passionate","Passive","Passive-aggressive","Pathetic","Patient","Patriotic","Peaceful","Penitent","Pensive","Perceptive","Perfect","Perfectionist","Performer","Persecuted","Perserverant","Perseveres","Persevering","Persistent","Personable","Persuasive","Pert","Perverse","Perverted","Pessimistic","Petrified","Petty","Petulant","Philanthropic","Picky","Pious","Pitiful","Pity","Placid","Playful","Pleasant","Pleased","Pleasing","Plotting","Plucky","Polished","Polite","Pompous","Poor","Poor communicator","Poor listener","Positive","Possessive","Power-hungry","Practical","Precise","Predictable","Preoccupied","Pressured","Presumptuous","Pretentious","Pretty","Prim","Primitive","Private","Productive","Profane","Professional demeanor","Promiscuous","Proper","Prosaic","Prosperous","Protective","Proud","Prudent","Psychotic","Puckish","Punctilious","Punctual","Purposeful","Pushy","Puzzled","Quarrelsome","Queer","Quick","Quick tempered","Quiet","Quirky","Quitter","Quixotic","Radical","Raging","Rambunctious","Random","Rash","Rational","Rawboned","Reactionary","Realistic","Reasonable","Reasoning","Rebellious","Recalcitrant","Receptive","Reckless","Reclusive","Refined","Reflective","Refreshed","Regretful","Rejected","Rejects change","Relaxed","Relentless","Relents","Reliable","Relieved","Religious","Reluctant","Remorseful","Remote","Repugnant","Repulsive","Resentful","Reserved","Resilient","Resolute","Resourceful","Respectful","Respects experience","Respects traditional ideas","Responsible","Responsive","Restless","Restrained","Results-oriented","Retiring","Reverent","Rewarded","Rhetorical","Right","Righteous","Rigid","Risk averse","Risk-taking","Robust and healthy","Rogue","Romantic","Rough","Rowdy","Rude","Rule-bound","Rule-conscious","Ruthless","Sacrificing","Sad","Sadistic","Safe","Sagely","Saintly","Salient","Sanctimonious","Sanguine","Sarcastic","Sassy","Satisfied","Saucy","Savage","Savvy","Scared","Scarred","Scary","Scattered","Scheming","Scornful","Scrawny","Screwed up","Scruffy","Secretive","Secure","Sedate","Seditious","Seductive","Sees the big picture","Selective","Self-absorbed","Self-assured","Self-blaming","Self-centered","Self-confident","Self-conscious","Self-controlling","Self-deprecating","Self-directed","Self-disciplined","Self-doubting","Self-effacing","Self-giving","Self-indulgent","Self-made","Self-reliant","Self-righteous","Self-satisfied","Self-serving","Self-sufficient","Selfish","Selfless","Senile","Sense of duty","Sensitive","Sensual","Sentimental","Serene","Serious","Servile","Settled","Sexual","Sexy","Shallow","Shameless","Sharp","Sharp-tongued","Sharp-witted","Sheepish","Shiftless","Shifty","Shocked","Short-tempered","Shows initiative","Shrewd","Shy","Silent","Silky","Silly","Simple","Simple-minded","Sincere","Sisterly","Skeptical","Skillful","Sleazy","Sloppy","Slovenly","Slow paced","Sluggish","Slutty","Sly","Small-minded","Smart","Smiling","Smooth","Sneaky","Snob","Snobbish","Sociable","Socially bold","Socially precise","Soft","Soft-hearted","Soft-spoken","Solemn","Solitary","Solution-oriented","Sophisticated","Sore","Sorrowful","Sorry","Sour","Spendthrift","Spiritual","Spiteful","Splendid","Spoiled","Spontaneous","Sports fan","Spunky","Squeamish","Staid","Startled","Stately","Static","Steadfast","Steady","Stern","Stimulating","Stingy","Stoic","Stoical","Stolid","Straight laced","Straight-laced","Straightforward","Strange","Stress free","Stressed out","Strict","Strident","Strong nerves","Strong willed","Stubborn","Studious","Stunned","Stupefied","Stupid","Suave","Submissive","Subtle","Successful","Successful in school","Successful in work","Succinct","Suffering","Sulky","Sullen","Sultry","Supercilious","Superstitious","Supportive","Sure","Surly","Suspicious","Suspicious of strangers","Sweet","Sycophantic","Sympathetic","Systematic","Taciturn","Tacky","Tactful","Tactless","Takes responsibility","Talented","Talkative","Tardy","Tasteful","Telepathic","Temperamental","Temperate","Tempted","Tenacious","Tender minded","Tense","Tentative","Tenuous","Terrible","Terrified","Testy","Thankful","Thankless","Thick skinned","Thief","Thorough","Thoughtful","Thoughtless","Threatened","Threatening","Thrifty","Thrilled","Thrillseeker","Thwarted","Tight","Time driven","Timid","Tired","Tireless","Tiresome","Toadying","Tolerant","Tolerates disorder","Torpid","Touchy","Tough","Tough-minded","Traditional","Traitorous","Tranquil","Treacherous","Treasonous","Tricky","Tries to do everything","Trivial","Troubled","Truculent","Trusting","Trustworthy","Truthful","Typical","Tyrannical","Unappreciative","Unapproachable","Unassuming","Unaware of own limitations","Unbending","Unbiased","Uncaring","Uncommitted","Uncommunicative","Unconcerned","Unconditional","Uncontrolled","Unconventional","Uncooperative","Uncoordinated","Uncouth","Undependable","Understanding","Undesirable","Undisciplined","Uneasy","Uneducated","Unenthusiastic","Unexacting","Unfeeling","Unfocused","Unforgiving","Unfriendly","Ungrateful","Unhappy","Unhelpful","Uninhibited","Unkind","Unlucky","Unmotivated","Unpredictable","Unprejudiced","Unpretentious","Unreasonable","Unreceptive","Unreliable","Unresponsive","Unrestrained","Unruly","Unscrupulous","Unselfish","Unsentimental","Unsettled","Unshakeable","Unsure","Unsuspecting","Unsuspicious","Unsympathetic","Unsystematic","Unusual","Unwilling","Unworried","Upbeat","Upset","Uptight","Useful","Utilitarian","Vacant","Vague","Vain","Valiant","Valorous","Values fair competition","Values family","Values hard work","Values honesty","Values material possessions","Values money","Values religion","Vehement","Vengeful","Venomous","Venturesome","Verbose","Versatile","Vicious","Vigilant","Vigorous","Vindictive","Violent","Virtuous","Visual","Vital","Vivacious","Volatile","Voracious","Vulgar","Vulnerable","Wanton","Warlike","Warm","Warm hearted","Wary","Wasteful","Watchful","Weak","Weak nerves","Weary","Weepy","Weird","Welcoming","Well grounded","Whimsical","Wholesome","Wicked","Wild","Willful","Willing","Willpower","Wise","Wishy washy","Withdrawn","Witty","Wonderful","Works well under pressure","Worldly","Worried","Worrying","Worshipful","Worships the devil","Worthless","Wretched","Xenophobic","Youthful","Zany","Zealot","Zealous","Sterile","Possessed","Psychopath"}
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





function RandGenUtil.generateMaleName()
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

function RandGenUtil.generateName()
	return RandGenUtil.generateMaleName()
end


function RandGenUtil.generateNameOld()
    numSyllables = math.random( 3 )
	print("gen'ing name, numSyllables=" .. numSyllables+1)

	local tmpName = "";
	for i = 1, numSyllables+1 do
		tmpName = tmpName .. syllables[math.random(#names)]	
	end
		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  name generated: " .. tmpName)

	return tmpName
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

function RandGenUtil.generateNpcRace()
	return races[math.random(#races)]
end

function RandGenUtil.generatePlaceType()
	return placeTypes[math.random(#placeTypes)]
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


function RandGenUtil.generatePlaceName(self, plType)
	local tmpName = "";

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

	if (nameStyle == 1) then -- Ariedor type name
		local numSyllables = math.random( 3 )
		print("gen'ing Ariedor type name, numSyllables=" .. numSyllables+1)

		if (nameOrder == 1) then
			tmpName = RandGenUtil.generateName() .. " " .. placeName
		else
			tmpName = placeName .. " " .. RandGenUtil.generateName()
		end			
	elseif (nameStyle == 2) then -- Blue Hills type name...
		print("gen'ing Blue Hills type name")
		
		if (nameOrder == 1) then
			tmpName = colorNames[math.random(#colorNames)] .. " " .. placeName
		else
			tmpName = placeName	.. " of " .. colorNames[math.random(#colorNames)]
		end
    elseif (nameStyle == 3) then -- Dusty Crypt type name...
    	print("gen'ing Dusty Crypt type name")
		
		tmpName = adjectives[math.random(#adjectives)] .. " " .. placeName

	else -- Agdon Fort type name
		print("gen'ing Agdon Fort type type name")
		local randNameTmp = RandGenUtil.generateName()
		
		if (nameOrder == 1) then
			tmpName = randNameTmp .. " " .. placeName
		else
			tmpName = placeName .. " of " .. randNameTmp
		end
	end

	print("  place name generated: " .. tmpName)

	return tmpName
end


function RandGenUtil.generateThingName( ) 
	local tmpName = "";

	tmpName = thingNames[math.random(#thingNames)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  thing generated: " .. tmpName)
	

	-- set the screen text
	-- thingResultString.text = tmpName
	return tmpName
end


function RandGenUtil.generateAdversary( ) 
	local tmpName = "";

	tmpName = adversaries[math.random(#adversaries)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  adversary generated: " .. tmpName)
	
	return tmpName
end


function RandGenUtil.generateObstacle( ) 
	local tmpName = "";

	tmpName = obstacles[math.random(#obstacles)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  obstacle generated: " .. tmpName)
	
	return tmpName
end

function RandGenUtil.generateQuestType( )
	return "simple"
end

function RandGenUtil.generateQuest( qType)
	local qTmp = "";
	print("==========================================================")
	print("RandGenUtil.generateQuest() called")
	local newQuest = quest.new("New Quest", "")

	local questStyle =  math.random( 5 )
	local placeType = Randomizer:generatePlaceType()

	newQuest:addQuestGiver( RandGenUtil:generateName() )

	if (questStyle == 1) then -- Gather: X has asked you to go to Y to retrieve Z
		local thing = RandGenUtil:generateThingName()
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
		local thing = RandGenUtil:generateThingName()
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to bring his "
		qTmp = qTmp .. thing .. " to " .. RandGenUtil:generateName()
		qTmp = qTmp .. " in " .. RandGenUtil:generatePlaceName(placeType)
		newQuest:setName( thing .. " delivery")
	elseif (questStyle == 5) then -- Escort: 
		local name = RandGenUtil:generateName()
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to escort "
		qTmp = qTmp .. name .. " to " 
		qTmp = qTmp .. RandGenUtil:generatePlaceName(placeType)
		newQuest:setName( name .. " escort")
	elseif (questStyle == 6) then -- Liberate:
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to save"
	elseif (questStyle == 7) then -- Summon/Build: 
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to build a"
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

		-- if (prep == 1) then
		-- 	prepPhrase = "On the way is"
		-- elseif (prep == 2) then
		-- 	prepPhrase = "On the way back is"
		-- elseif (prep == 3) then
		-- 	if (wrinkleType == 2) then 
		-- 		prepPhrase = "Guarding it is"
		-- 	else
		-- end

		if (wrinkleType == 1) then -- Obstacle:
			while ( prepPhrase == "Guarding it is") do
				prepPhrase = RandGenUtil.genPrepPhrase()
			end
			qTmp = qTmp .. "Wrinkle: " .. prepPhrase .. " " .. RandGenUtil:generateObstacle() .. "\n"
		elseif (wrinkleType == 2) then -- Monster: 
			qTmp = qTmp .. "Wrinkle: " .. prepPhrase .. " " .. RandGenUtil:generateAdversary() .. "\n"
		elseif (wrinkleType == 3) then -- Prerequisite: 
			qTmp = qTmp .. "Wrinkle: First you must find " .. quest.questGiver .. "'s"
			qTmp = qTmp .. "    " .. RandGenUtil:generateThingName() .. "\n"
		end
	end
	
	print ("RandGenUtil.generateQuest - Random Quest Details Generated: " .. qTmp)
	return qTmp
end

 -- Initialize the RandGenUtil
RandGenUtil:new()
RandGenUtil:initialize()


return RandGenUtil