
if GetLocale() ~= "frFR" then return end
local _, tbl = ...
local L = tbl.locale

L["activatedRing"] = "%s a activé %s (%s)"
L["add"] = "Ajouter"
L["align"] = "Alignement"
L["allSpells"] = "Tous les sorts sélectionnés"
L["announce"] = "Annoncer"
L["announceDesc"] = "Affiche un message au raid quand un anneau s'active."
L["autoLootMethod"] = "Définir auto. le mode du butin en rejoignant un groupe"
L["autoLootMethodDesc"] = "Laisse oRA3 définir automatiquement la méthode de fouille selon ce que vous avez spécifié ci-dessous quand vous entrez dans un groupe (de raid)."
L["average"] = "Moyenne"
L["backgroundColor"] = "Couleur de l'arrière-plan"
L["barDisplay"] = "Barres"
L["barDisplayDesc"] = "simple affichage sous forme de barres."
L["barSettings"] = "Paramètres des barres"
L["battleResHeader"] = "Le moniteur ne sera affiché que quand vous vous trouvez dans un groupe dans une instance de raid."
L["battleResLockDesc"] = "Verrouille ou non le moniteur. Ceci masquera le texte d'en-tête, l'arrière-plan, et empêchera son déplacement."
L["battleResShowDesc"] = "Affiche ou cache le moniteur."
L["battleResTitle"] = "Moniteur rez combat"
L["blizzMainTank"] = "Tank principal Blizzard"
L["broken"] = "Cassé"
L["buffs"] = "Buffs"
L["byGuildRank"] = "Par rang de guilde"
L["center"] = "Centre"
L["checkBuffs"] = "Vérification des buffs"
L["checkBuffsDesc"] = "Inclure les buffs de raid lors de la vérification des buffs."
L["checkFlaskDesc"] = "Inclure les flacons lors de la vérification des buffs."
L["checkFoodDesc"] = "Inclure les buffs de nourriture lors de la vérification des buffs."
L["checkReadyCheck"] = "Vérification lors de l'appel"
L["checkReadyCheckDesc"] = "Vérifie les buffs quand un appel est lancé." -- Needs review
L["checkRuneDesc"] = "Inclure les runes d'amélioration lors de la vérification des buffs."
L["checks"] = "Vérif."
L["clear"] = "Effacer"
L["clickable"] = "Cliquable"
L["clickableDesc"] = "Permet de cliquer sur votre icône d'anneau pour l'activer."
L["consumables"] = "Vérif. des consommables"
L["cooldowns"] = "Recharges"
L["cooldownsEnableDesc"] = "La désactivation du module l'empêchera de consommer des ressources pour surveiller les temps de recharge quand vous êtes en groupe."
L["copyDisplay"] = "|cff02ff02Copier %s|r"
L["createNewDisplay"] = "|cff02ff02Créer un nouvel affichage|r"
L["customColor"] = "Couleur personnalisée"
L["dead"] = "mort"
L["deleteButtonHelp"] = "Enlève ce joueur de la liste des tanks."
L["deleteDisplay"] = "|cffff0202Supprimer %s|r"
L["demoteEveryone"] = "Dégrader tout le monde"
L["demoteEveryoneDesc"] = "Dégrade toutes les personnes présentes dans le groupe actuel."
L["direction"] = "Direction"
L["directionThen"] = "%s et ensuite %s"
L["disabledAlpha"] = "Transparence des barres désactivées"
L["disbandGroup"] = "Dissoudre raid"
L["disbandGroupDesc"] = [=[Dissout votre groupe ou raid actuel en renvoyant ses membres un par un jusqu'à ce que vous soyez le dernier présent.

Comme il s'agit d'une méthode radicale, une fenêtre de dialogue de confirmation vous sera présentée. Maintenez enfoncé la touche Contrôle pour éviter son apparition.]=]
L["disbandGroupWarning"] = "Êtes-vous sûr de vouloir dissoudre votre groupe ?"
L["disbandingGroupChatMsg"] = "Dissolution du groupe de raid."
L["displaySettings"] = "Paramètres d'affichage"
L["displayTypes"] = "Types d'affichage"
L["down"] = "Bas"
L["durability"] = "Durabilité"
L["duration"] = "Durée"
L["durationTextSettings"] = "Paramètres du texte de durée"
L["ensureRepair"] = "S'assurer que les réparations de guilde sont activées pour tous les rangs du raid"
L["ensureRepairDesc"] = "Si vous êtes le maître de guilde, à chaque fois que vous rejoignez un groupe de raid dans lequel vous êtes chef ou assistant, ceci s'assurera que les réparations de guilde sont activées pendant la durée du raid (jusqu'à 300po). Une fois que vous quittez le groupe de raid, les marqueurs retrouveront leur état initial |cffff4411à condition que votre jeu ne crash pas pendant le raid.|r"
L["fill"] = "Remplir les barres"
L["filtersDesc"] = "Définit ce que vous souhaitez exclure de l'affichage."
L["flask"] = "Flacon"
L["flaskExpires"] = "Votre flacon se termine dans moins de 10 minutes"
L["font"] = "Police d'écriture"
L["fontSize"] = "Taille de police"
L["food"] = "Bouffe"
L["gap"] = "Espace entre les barres"
L["gear"] = "Équipement"
L["group"] = "Groupe"
L["groupSpells"] = "Garder les sorts triés par classe"
L["growUpwards"] = "Ajouter vers le haut"
L["guildKeyword"] = "Mot-clé de guilde"
L["guildKeywordDesc"] = "Tout membre de votre guilde qui vous chuchote ce mot-clé sera automatiquement et immédiatement invité dans votre groupe de raid."
L["guildRankInvites"] = "Invitation selon le rang de guilde"
L["guildRankInvitesDesc"] = "En cliquant sur un des boutons ci-dessous, vous inviterez toutes les personnes du rang choisi ainsi que ceux des rangs SUPÉRIEURS dans votre groupe de raid, à moins que vous ne mainteniez la touche SHIFT enfoncée. Ainsi, cliquer sur le 3e bouton invitera toutes les personnes des rangs 1,2 et 3, tandis que maintenir SHIFT enfoncé et cliquer sur le 3e bouton invitera uniquement les membres du rang 3. Un message sera affiché dans le canal guilde ou officier et laissera 10 secondes à vos membres de guilde pour quitter leurs groupes afin de lancer les invitations." -- Needs review
L["guildRepairs"] = "Réparations de guilde"
L["height"] = "Hauteur"
L["hideDead"] = "Cacher quand mort"
L["hideGroupDesc"] = "Cache les temps de recharge des joueurs de ce groupe."
L["hideInCombat"] = "Cacher en combat"
L["hideInCombatDesc"] = "Cache automatiquement la fenêtre d'appel quand vous entrez en combat."
L["hideInInstanceDesc"] = "Cache les temps de recharge dans ce type d'instance."
L["hideOffline"] = "Cacher quand déconnecté"
L["hideOutOfCombat"] = "Cacher quand hors de combat"
L["hideOutOfRange"] = "Cacher quand hors de portée"
L["hideReadyPlayers"] = "Cacher les joueurs qui sont prêts"
L["hideReadyPlayersDesc"] = "Enlève les joueurs qui sont prêt de la fenêtre."
L["hideRolesDesc"] = "Cache les temps de recharge des joueurs ayant ce rôle."
L["hideWhenDone"] = "Cacher la fenêtre une fois fini"
L["hideWhenDoneDesc"] = "Cache automatiquement la fenêtre quand l'appel est terminé."
L["home"] = "Domicile"
L["horizontal"] = "Horizontal"
L["icon"] = "Icône"
L["iconDisplay"] = "Icônes"
L["iconDisplayDesc"] = "simple affichage sous forme d'icônes"
L["iconGroupDisplay"] = "Groupes d'icônes"
L["iconGroupDisplayDesc"] = "affiche toutes les incantations disponibles pour un sort en une seule icône."
L["individualPromotions"] = "Promotions individuelles"
L["individualPromotionsDesc"] = "Notez que les noms sont sensibles à la casse. Pour ajouter un joueur, entrez son nom dans la boîte de saisie ci-dessous et appuyez sur Entrée ou cliquez sur le bouton qui apparaît. Pour enlever un joueur, cliquez tout simplement sur son nom dans le menu déroulant ci-dessous."
L["invite"] = "Inviter"
L["inviteDesc"] = "Toute personne vous chuchotant un des mots-clés ci-dessous sera automatiquement invité dans votre groupe de raid. Si vous êtes dans un groupe complet, ce dernier sera converti en groupe de raid. Le mot-clé cessera de fonctionner une fois le groupe de raid complet. Ne mettez rien comme mots-clés pour désactiver cette fonction."
L["inviteGuild"] = "Inviter la guilde"
L["inviteGuildDesc"] = "Invite tous les membres de votre guilde de niveau maximal."
L["inviteGuildRankDesc"] = "Invite tous les membres de votre guilde ayant le rang %s ou supérieur."
L["inviteInRaidOnly"] = "Inviter uniquement par mot-clé si dans un groupe de raid"
L["invitePrintGroupIsFull"] = "Désolé, le groupe de raid est complet."
L["invitePrintMaxLevel"] = "Tous les personnages de niveau maximal seront invités dans le raid dans 10 sec. Veuillez quitter vos groupes."
L["invitePrintRank"] = "Tous les personnages de rang %s ou supérieur seront invités dans le raid dans 10 sec. Veuillez quitter vos groupes."
L["invitePrintRankOnly"] = "Tous les personnages du rang %s seront invités dans le raid dans 10 secondes. Veuillez quitter vos groupes."
L["invitePrintZone"] = "Tous les personnages se trouvant à %s seront invités dans le raid rans 10 sec. Veuillez quitter vos groupes."
L["inviteZone"] = "Inviter la zone"
L["inviteZoneDesc"] = "Invite tous les membres de votre guilde se trouvant dans la même zone que vous."
L["itemLevel"] = "Niveau d'objet"
L["keyword"] = "Mot-clé"
L["keywordDesc"] = "Toute personne qui vous chuchote ce mot-clé sera automatiquement et immédiatement invité dans votre groupe de raid."
L["keywordMultiDesc"] = "Vous pouvez utiliser plusieurs mot-clés en les séparant avec le caractère ; (point virgule)."
L["labelTextSettings"] = "Paramètre du texte du libellé"
L["latency"] = "Latence"
L["left"] = "Gauche"
L["legendaryRings"] = "Anneaux légendaires"
L["lockMonitor"] = "Verrouiller le moniteur"
L["lockMonitorDesc"] = "Notez que le verrouillage du moniteur des temps de regarde cachera le titre et la poignée de saisie, rendant ainsi le moniteur impossible à déplacer ou à redimensionner. Il ne sera également pas possible d'ouvrir le menu des options des barres."
L["logDisplay"] = "Journal"
L["logDisplayDesc"] = "simple cadre où les messages sont envoyés quand un sort est utilisé."
L["makeLootMaster"] = "Laissez vide pour faire de vous le maître du butin."
L["massPromotion"] = "Nomination en masse"
L["minimum"] = "Minimum"
L["missingBuffs"] = "Buffs manquants"
L["missingEnchants"] = "Enchantements manquants"
L["missingGems"] = "Gemmes manquantes"
L["moveTankUp"] = "Cliquez pour faire monter ce tank."
L["name"] = "Nom"
L["neverShowOwnSpells"] = "Ne jamais afficher mes propres sorts"
L["neverShowOwnSpellsDesc"] = "Enlève ou non vos propres temps de recharge de l'affichage des temps de recharge. À cocher par exemple si vous utilisez un autre addon pour afficher vos temps de recharge."
L["noFlask"] = "Pas de flacon"
L["noFood"] = "Pas bien nourri"
L["noResponse"] = "Pas de réponse"
L["noRune"] = "Pas de rune d'amélioration"
L["noSpells"] = "Aucun sort sélectionné !"
L["notBestBuff"] = "Pas le consommable avec les plus hautes stats de disponible"
L["notInRaid"] = "Vous n'êtes pas dans un raid d'instance."
L["notReady"] = "Pas prêt"
L["offline"] = "Hors ligne"
L["onlyMyOwnSpells"] = "Afficher uniquement mes propres sorts"
L["onlyMyOwnSpellsDesc"] = "Affiche ou non uniquement les temps de recharge concernant votre personnage."
L["onlyMyRing"] = "Uniquement mon anneau"
L["onlyMyRingDesc"] = "Joue un son uniquement quand votre type d'anneau s'active."
L["onlyRaids"] = "Afficher uniquement en raid"
L["onlyRaidsDesc"] = "Affiche le moniteur uniquement quand vous êtes dans un groupe de raid."
L["options"] = "Options"
L["orientation"] = "Orientation"
L["outline"] = "Contour"
L["outOfRange"] = "Joueur hors de portée"
L["output"] = "Sortie"
L["outputDesc"] = "Affiche les résultats soit dans la discussion de groupe, soit dans votre de discussion par défaut."
L["outputMissing"] = "Sortie manquante" -- Needs review
L["playersNotReady"] = "Les joueurs suivants ne sont pas prêts : %s"
L["playerStatus"] = "Statut du joueur"
L["popupConvertDisplay"] = "Modifier le type d'affichage réinitialisera les paramètres spécifiques à l'affichage !"
L["popupDeleteDisplay"] = "Supprimer l'affichage '%s' ?"
L["popupNameError"] = [=[Il existe déjà un affichage nommé '%s'.
Veuillez choisir un autre nom.]=]
L["popupNewDisplay"] = "Entrez le nom du nouvel affichage"
L["printToRaid"] = "Transmettre le résultat des appels au canal Raid"
L["printToRaidDesc"] = "Si vous êtes au moins assistant, transmet le résultat des appels au canal Raid afin que tous les membres du raid puissent voir la raison du retard. Assurez-vous d'être la seule personne à avoir activé ceci."
L["profile"] = "Profil"
L["promote"] = "Nomination"
L["promoteEveryone"] = "Tout le monde"
L["promoteEveryoneDesc"] = "Nomme automatiquement assistants tout le monde."
L["promoteGuild"] = "Guilde"
L["promoteGuildDesc"] = "Nomme automatiquement assistants tous les membres de votre guilde."
L["raidBuffs"] = "Buffs de raid"
L["range"] = "hors de portée"
L["ready"] = "Prêt"
L["readyByGroup"] = "Relayer les résultats de l'appel selon la difficulté du raid"
L["readyByGroupDesc"] = "Ignore les joueurs qui ne sont pas dans les groupes liés à la difficulté d'instance actuelle. Par exemple, ignore les joueurs des groupes 5 à 8 dans les raids mythiques. L'appel se terminera quand tous les joueurs des groupes pertinents sont prêts."
L["readyCheckSeconds"] = "Appel (%d |4seconde:secondes;)"
L["readyCheckSound"] = "Joue le son de l'appel en utilisant le canal principal du son quand un appel est effectué. Ceci jouera le son même si \"Effets sonores\" est désactivé et à un volume supérieur."
L["remove"] = "Enlever"
L["repairAmount"] = "Limite de réparation"
L["repairAmountDesc"] = "Le montant maximal d'or que chaque joueur est autorisé à utiliser pour ses réparations."
L["repairEnabled"] = "Réparations de guilde activées pour %s pendant la durée de ce raid."
L["reportAlways"] = "Toujours rapporter"
L["reportIfYou"] = "Rapporter si lancé par vous"
L["right"] = "Droite"
L["rightClick"] = "Clic droit pour les options !"
L["rune"] = "Rune"
L["save"] = "Sauver"
L["saveButtonHelp"] = "Sauvegarde ce tank dans votre liste personnelle. Chaque fois que vous serez groupé avec ce joueur, il sera indiqué comme étant un tank personnel."
L["scale"] = "Échelle"
L["selectClass"] = "Choix de la classe"
L["selectClassDesc"] = "Choississez les temps de recharge à afficher en vous aidant du menu déroulant et des cases à cocher ci-dessous. Chaque classe possède un nombre limité de sorts que vous pouvez voir via l'affichage par barres. Choissisez une classe via le menu déroulant et configurer ses sorts selon vos besoins."
L["self"] = "Soi-même"
L["shortSpellName"] = "Nom des sorts raccourcis"
L["show"] = "Afficher"
L["showBuffs"] = "Affichage des buffs"
L["showButtonHelp"] = "Affiche ce tank dans votre affichage des tanks personnels. Cette option n'a des effets que localement et ne changera pas son statut de tank pour tous les autres membres du groupe."
L["showCooldownText"] = "Afficher le texte des temps de recharge"
L["showCooldownTextDesc"] = "Affiche le texte des temps de recharge de Blizzard"
L["showCurrentBuffs"] = "Afficher les buffs actuels"
L["showHelpTexts"] = "Afficher l'aide de l'interface"
L["showHelpTextsDesc"] = "L'interface de oRA3 est remplie de textes d'aide permettant de mieux comprendre les différents éléments de l'interface. Désactiver cette option enlèvera ces textes, limitant l'encombrement sur chaque panneau. |cffff4411Nécessite parfois un rechargement de l'interface.|r"
L["showMissingBuffs"] = "Afficher les buffs manquants"
L["showMissingMaxStat"] = "Afficher les consommables inférieurs comme manquant"
L["showMissingMaxStatDesc"] = "Affiche les icônes pour les buffs de nourriture et de flacon avec une couleur différente pour indiquer qu'il ne s'agit pas de la valeur de stat la plus haute de disponible."
L["showMissingRunes"] = "Afficher les runes d'amélioration"
L["showMissingRunesDesc"] = "Intègre l'affichage d'une icône pour les buffs des Runes d'améliorations."
L["showMonitor"] = "Afficher le moniteur"
L["showMonitorDesc"] = "Affiche ou non l'affichage des temps de recharge via des barres."
L["showRings"] = "Anneaux à afficher"
L["showRoleIcons"] = "Afficher les icônes de rôle sur le panneau raid"
L["showRoleIconsDesc"] = "Affiche les icônes de rôle et le nombre total de chaque rôle sur le panneau de raid Blizzard. Vous devrez réouvrir le panneau de raid pour que les changements de ce paramètre prennent effet."
L["showText"] = "Afficher le texte"
L["showTextDesc"] = "Affiche le type d'anneau ou le nom du dernier joueur qui a utilisé l'anneau."
L["showWindow"] = "Afficher la fenêtre"
L["showWindowDesc"] = "Affiche la fenêtre quand un appel est lancé."
L["skin"] = "Skin Masque"
L["slashCommands"] = [=[oRA3 supporte toute une série de commandes « / » (ou slash) pour vous aider rapidement en raid.

|cff44ff44/racd|r - ouvre les paramètres de temps de recharge.
|cff44ff44/rabuffs|r - ouvre la liste des buffs et affiche les résultats.
|cff44ff44/radur|r - ouvre la liste des durabilités.
|cff44ff44/ragear|r - ouvre la liste des vérifications de l'équipement.
|cff44ff44/ralag|r - ouvre la liste des latences.
|cff44ff44/razone|r - ouvre la liste des zones.
|cff44ff44/racheck|r - ouvre la fenêtre des vérifications de raid.
|cff44ff44/radisband|r - dissout instantanément le raid sans vérification.
|cff44ff44/raready|r - fait l'appel.
|cff44ff44/rainv|r - invite l'entièreté de la guilde dans votre groupe de raid.
|cff44ff44/razinv|r - invite les membres de la guilde situés dans votre zone.
|cff44ff44/rarinv <nom du rang>|r - invite les membres de la guilde du rang donné.]=] -- Needs review
L["slashCommandsHeader"] = "Commandes « / »"
L["sort"] = "Trier"
L["sound"] = "Son"
L["soundDesc"] = "Joue un son quand un anneau s'active."
L["spacing"] = "Espacement"
L["spellName"] = "Nom du sort"
L["spellTooltip"] = "Afficher les bulles d'aide des sorts"
L["style"] = "Style de barre"
L["tankButtonHelp"] = "Définit ou non ce joueur comme étant un tank principal Blizzard."
L["tankHelp"] = [=[Les joueurs de la liste du haut sont vos tanks personnels triés. Ils ne sont pas partagés avec le raid, et tout le monde peut avoir une liste de tanks personnelle différente. Cliquer sur un nom de la liste du bas permet d'ajouter le joueur dans votre liste personnelle.

Cliquer sur l'icône en forme de bouclier ajoutera cette personne dans la liste des tanks principaux de Blizzard. Les tanks de Blizzard sont partagées entre tous les membres de votre raid et vous devez être au moins assistant pour faire cela.

Les tanks qui apparaissent dans la liste car ajoutés par quelqu'un d'autre dans la liste des tanks principaux de Blizzard seront enlevés de la liste une fois qu'ils ne sont plus des tanks principaux de Blizzard.

Utiliser la coche pour sauvegarder un tank entre les sessions. La prochaine fois que vous serez dans un raid avec cette personne, il sera automatiquement définit comme étant un tank personnel.]=]
L["tanks"] = "Tanks"
L["tankTabTopText"] = "Cliquez sur les joueurs de la liste du bas pour les nommer tank personnel. Si vous souhaitez obtenir de l'aide, survolez le '?' avec votre souris."
L["test"] = "Test"
L["texture"] = "Texture"
L["thick"] = "Épais"
L["thin"] = "Mince"
L["timestamp"] = "Afficher les horodatages"
L["timeVisible"] = "Durée de visibilité (0 = toujours)"
L["toggleMonitor"] = "Afficher/cacher moniteur" -- Needs review
L["togglePane"] = "Panneau oRA3 on/off"
L["toggleWithRaid"] = "Ouvrir avec le panneau de raid"
L["toggleWithRaidDesc"] = "Ouvre et ferme le panneau de oRA3 automatiquement en même temps que le panneau de raid de Blizzard. Si vous désactivez cette option, vous pouvez toujours ouvrir le panneau de oRA3 en utilisant son raccourci clavier ou une commande slash, telle que |cff44ff44/radur|r."
L["unitName"] = "Nom unité"
L["unknown"] = "Inconnu"
L["up"] = "Haut"
L["useClassColor"] = "Couleur de classe"
L["vertical"] = "Vertical"
L["whatIsThis"] = "Qu'est-ce que tout cela ?"
L["whisperMissing"] = "Chuchoter aux fautifs"
L["whisperMissingDesc"] = "Chuchote aux joueurs à qui il manque des buffs."
L["world"] = "Monde"
L["zone"] = "Zone"
