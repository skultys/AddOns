
if GetLocale() ~= "itIT" then return end
local _, tbl = ...
local L = tbl.locale

L["add"] = "Aggiungi"
L["autoLootMethod"] = "imposta automaticamente la modalità di depredamento quando entri in un gruppo o incursione"
L["autoLootMethodDesc"] = "Lascia che sia oRA3 ad impostare automaticamente la modalità di depredamento con le modalità impostate successivamente quando entri in un gruppo od incursione."
L["average"] = "Media"
L["barSettings"] = "Impostazioni Barra"
L["blizzMainTank"] = "Difensori Principali Blizzard"
L["broken"] = "Rotto"
L["byGuildRank"] = "Per Rango di Gilda"
L["center"] = "Centro"
L["checks"] = "Controlli"
L["cooldowns"] = "Recuperi"
L["customColor"] = "Colore personalizzato"
L["deleteButtonHelp"] = "Rimuovi dalla lista dei Difensori. Attenzione: una volta rimosso un giocatore dalla lista, non verrà riaggiunto automaticamente per tutta la durata della sessione, a meno di riaggiungerlo manualmente."
L["demoteEveryone"] = "Degrada tutti"
L["demoteEveryoneDesc"] = "Degrada tutti nel gruppo attuale."
L["disbandGroup"] = "Sciogli Incursione"
L["disbandGroupDesc"] = [=[Sciogli la tua spedizione o incursione attuale, espellendo chiunque dal tuo gruppo, uno per uno, fino a che non sarai l'ultimo rimasto.

Dato che questa azione è potenzialmente molto distruttiva, ti verrà presentata una finesta di conferma. Tieni premuto Control per eliminare questa finestra.]=]
L["disbandGroupWarning"] = "Sei sicuro di voler sciogliere il tuo gruppo?"
L["disbandingGroupChatMsg"] = "Scioglimento gruppo"
L["durability"] = "Integrità"
L["duration"] = "Durata"
L["ensureRepair"] = "Assicura che le riparazioni di gilda sono abilitate per tutti i ranghi presenti nell'incursione"
L["ensureRepairDesc"] = "Se sei il Capogilda, quando entri in un gruppo d'incursione e sei o il capoincursione oppure vieni promosso, viene assicurato che tu lo sarai per tutta la durata dell'incursione (fino a 300 giorni). Quando esci dal gruppo, verrà tutto ripristinato ai valori predefiniti |cffff4411a patto che tu non abbia subito crash del gioco durante l'incursione.|r"
L["gear"] = "Armatura"
L["growUpwards"] = "Crescente"
L["guildKeyword"] = "Parola chiave di Gilda"
L["guildKeywordDesc"] = "Qualsiasi membro di Gilda che ti sussurrerà questa parola verrà invitato instantaneamente ed automaticamente nel tuo gruppo."
L["guildRankInvites"] = "Inviti Grado di Gilda"
L["guildRankInvitesDesc"] = "Cliccando su uno dei pulsanti sottostanti inviterà chiunque abbia quel rango E TUTTI QUELLI DI RANGO SUPERIORE nel tuo gruppo. Quindi, cliccando sul terzo pulsante inviterà chiunque abbia il rango 1, 2 e 3. Verrà inviato un'avviso nella chat di gilda e degli ufficialie darà 10 secondi di tempo a tutti i mebri per uscire dai loro gruppi prima di essere invitati nel tuo." -- Needs review
L["height"] = "Altezza"
L["hideInCombat"] = "Nascondi in combattimento"
L["hideInCombatDesc"] = "Nascondi automaticamente la finestra dell'appello quando entri in combattimento."
L["hideReadyPlayers"] = "Nascondi giocatori che sono pronti"
L["hideReadyPlayersDesc"] = "Nascondi i giocatori che sono segnalati dalla finestra come pronti."
L["hideWhenDone"] = "Nascondi la finestra quando terminato"
L["hideWhenDoneDesc"] = "Nascondi automaticamente la finestra quando l'appello è terminato."
L["home"] = "Locale"
L["icon"] = "Icona"
L["individualPromotions"] = "Promozione individuale"
L["individualPromotionsDesc"] = "Attenzione: i nomi sono case sensitive. Per aggiungere un giocatore, scrivi il suo nome nel riquadro sottostante e premi Invio oppure clicca sul pulsante che apparirà. Per rimuovere un giocatore dalla lista dei promossi automaticamente, basta cliccare sul suo nome nel menù a scomparsa sotto."
L["invite"] = "Invita"
L["inviteDesc"] = "Quando qualcuno ti sussurrerà la parola chiave, verranno automaticamente invitati nel tuo gruppo. Se sei in un gruppo ed è pieno, verrà convertito in un gruppo d'incursione. La parola chiave smetterà di funzionare sontanto quando il tuo gruppo sarà di 40 unità. Questa funzione verrà disabilitata quando non si imposterà nessuna Parola Chiave."
L["inviteGuild"] = "Invita Gilda"
L["inviteGuildDesc"] = "Invita tutti i membri di gilda di livello massimo."
L["inviteGuildRankDesc"] = "Invita tutti i membri di gilda di grado %s o maggiore." -- Needs review
L["inviteInRaidOnly"] = "Invita soltanto con Parola Chiave se sei in un gruppo incursione"
L["invitePrintGroupIsFull"] = "Spiacente, il gruppo è completo."
L["invitePrintMaxLevel"] = "Tutti i personaggi di livello massimo verranno invitati nell'incursione tra 10 secondi. Per favore uscite dai vostri gruppi."
L["invitePrintRank"] = "Tutti i personaggi di grado %s o maggiore verranno invitati nell'incursione tra 10 secondi. Per favore uscite dai vostri gruppi."
L["invitePrintZone"] = "Tutti i personaggi nella zona %s verranno invitati nell'incursione tra 10 secondi. Per favore uscite dai vostri gruppi."
L["inviteZone"] = "Invita zona"
L["inviteZoneDesc"] = "Invita tutti i membri di gilda che sono nella tua stessa zona"
L["itemLevel"] = "Livello Oggetto"
L["keyword"] = "Parola chiave"
L["keywordDesc"] = "Chiunque ti sussurrerà questa parola verrà invitato instantaneamente ed automaticamente nel tuo gruppo."
L["labelTextSettings"] = "Impostazioni Testo Etichetta"
L["latency"] = "Latenza"
L["left"] = "Sinistra"
L["lockMonitor"] = "Blocca monitor"
L["lockMonitorDesc"] = "Bloccare il monitor dei recuperi nasconderà la barra del titolo e l'angolo per muovere il riquadro, rendendo impossibile muoverlo, riposizionarlo ed ingrandirlo ed anche di mostrare le opzioni della barra."
L["makeLootMaster"] = "Lascia vuoto per impostare te stesso come Responsabile del Bottino."
L["massPromotion"] = "Promozione di massa"
L["minimum"] = "Minimo"
L["missingEnchants"] = "Incantamenti Mancanti"
L["missingGems"] = "Gemme Mancanti"
L["moveTankUp"] = "Clicca per portare in alto questo difensore"
L["name"] = "Nome"
L["neverShowOwnSpells"] = "Non mostrare mai i miei incantesimi"
L["neverShowOwnSpellsDesc"] = "Attiva o no la visualizzazione sul monitor dei recuperi di quelli relativi ai tuoi incantesimi o abilità. Per esempio, se usi un'altro addon per tenere traccia dei tuoi recuperi."
L["noResponse"] = "Nessuna Risposta"
L["notReady"] = "Non Pronto"
L["offline"] = "Disconnesso"
L["onlyMyOwnSpells"] = "Mostra solo i miei incantesimi"
L["onlyMyOwnSpellsDesc"] = "Attiva la visualizzazione dei recuperi solo per i tuoi incantesimi, rendendolo di fatto un semplice addon per monitorare i recuperi."
L["options"] = "Opzioni"
L["printToRaid"] = "Visualizza i risultati dell'appello nella chat d'incursione"
L["printToRaidDesc"] = "Se sei stato promosso, visualizza i risultati degli appelli nella chat d'incursione, permettendo a tutti i membri dell'incursione di sapere chi è che li sta facendo ritardare. Assicurati che solo una persona abbia attivato questa opzione."
L["profile"] = "Profilo"
L["promote"] = "Promuovi"
L["promoteEveryone"] = "Chiunque"
L["promoteEveryoneDesc"] = "Promuovi tutti automaticamente"
L["promoteGuild"] = "Gilda"
L["promoteGuildDesc"] = "Promuove automaticamente tutti i membri di Gilda"
L["ready"] = "Pronto"
L["readyCheckSeconds"] = "Appello (%d secondi)"
L["readyCheckSound"] = "Esegui il suono dell'appello usando il dispositivo principale quando viene eseguito un'appello. Verrà eseguito il suono quando l'opzione \"Effetti audio\" è disabilitata e ad un volume maggiore."
L["remove"] = "Rimuovi"
L["repairEnabled"] = "Abilita le riparazioni di gilda per %s per tutta la durata di questa incursione."
L["right"] = "Destra"
L["rightClick"] = "Clic_Destro su di me per le opzioni!"
L["save"] = "Salva"
L["saveButtonHelp"] = "Salva il Difensore nella tua lista personale. Ogni volta che sarai in gruppo con questo giocatore verrà elencato come tank personale."
L["scale"] = "Scalatura"
L["selectClass"] = "Seleziona classe"
L["selectClassDesc"] = "Seleziona quali recuperi mostrare usando il menù a tendina e i segni di spunta sottostanti. Ogni classe ha un certo numero di incantesimi disponibili per poterne vedere i tempi di recupero. Seleziona una classe dal menù a scomparsa e poi configura quali incantesimi di classe monitorare per i tuoi bisogni."
L["shortSpellName"] = "Nome abilità corto"
L["show"] = "Mostra"
L["showButtonHelp"] = "Mostra questo difensore nella tua lista personale. Questa opzione ha solo effetto locale e non cambierà lo status dei difensori della tua incursione."
L["showHelpTexts"] = "Mostra aiuti interfaccia"
L["showHelpTextsDesc"] = "L'interfaccia di oRA3 è piena di testi utili per descrivere meglio che sta succedendo e che cosa facciano esattamente i vari elementi dell'interfaccia. Disabilitare questa opzione rimuove questi aiuti, limitando il disordine nei vari pannelli. |cffff4411Richiede il ricaricamento dell'interfaccia in alcuni pannelli.|r"
L["showMonitor"] = "Mostra monitor"
L["showMonitorDesc"] = "Mostra o nascondi la barra del recupero nel mondo di gioco."
L["showRoleIcons"] = "Mostra icona di ruolo nel pannello Incursione"
L["showRoleIconsDesc"] = "Mostra l'icona del ruolo e il conteggio totale di ogni ruolo nel pannello Incursione della Blizzard. Devi riaprire il pannello incursione per applicare le modifiche."
L["showWindow"] = "Mostra Finestra"
L["showWindowDesc"] = "Mostra la finestra quando viene eseguito un'appello."
L["slashCommands"] = [=[oRA3 dispone di una serie di comandi slash per aiutarti a configurare velocemente le incursioni. Se non eri presente quando c'era CTRA, ecco una piccola lista. Tutti i comandi slash hanno varie scorciatoie ma anche versioni più lunghe, e descrizioni alternative in alcuni casi.

|cff44ff44/racd|r - Apre le impostazioni di cooldown.
|cff44ff44/radur|r - Apre la lista di Integrità.
|cff44ff44/ragear|r - Apre la lista del Controllo Equipaggiamento.
|cff44ff44/ralag|r - Apre la lista della latenza.
|cff44ff44/razone|r - Apre la lista delle Zone.
|cff44ff44/radisband|r - Sciogli immediatamente l'incursione, senza nessuna verifica.
|cff44ff44/raready|r - Esegue un'appello.
|cff44ff44/rainv|r - Invita tutta la gilda nel tuo gruppo.
|cff44ff44/razinv|r - Invita i membri di gilda nella tua stessa zona.
|cff44ff44/rarinv <rank name>|r - Invita i membri di gilda di un determinato Grado.]=] -- Needs review
L["slashCommandsHeader"] = "Comandi Slash"
L["sort"] = "Ordina"
L["spellName"] = "Nome Abilità"
L["tankButtonHelp"] = "Attiva per rendere il Difensore un Difensore Principale Blizzard."
L["tankHelp"] = [=[I giocatori in questa lista sono i tuoi difeosori personali preferiti. Non sono condivisi con il resto dell'incursione e ognuno può avere la sua propria lista. Cliccare su un nome della lista lo aggiungerà alla tua lista di Difensori Personali.

Cliccare sull'icona dello Scudo renderà il giocatore un Difensore Principale Blizzard. I Difensori Blizzard sono condivisi tra tutti i membri del gruppo e devi essere promosso per attivare questa funzione.

I Difensori che appaiono in questa lista perché sono stati resi tali da altre persone verranno rimossi quando non saranno più dei Difensori Principali Blizzard.

Usate il segno di spunta verde per salvare il difensore tra due diverse sessioni. La volta successiva che sarai in gruppo con quel giocatore, verrà automaticamente impostato come Difensore Personale.]=]
L["tanks"] = "Difensori"
L["tankTabTopText"] = "Clic sui giocatori nella lista seguente per renderli dei difensori personali. Se hai bisogno di aiuto con tutte le opzioni disponibili muovi il mouse sul punto di domanda."
L["texture"] = "Texture"
L["togglePane"] = "Attiva pannello oRA3"
L["toggleWithRaid"] = "Attiva con il pannello incursione"
L["toggleWithRaidDesc"] = "Apre e chiude automaticamente il pannello di oRA3 insieme a quello Blizzard per le incursioni. Se disabiliti questa opzione puoi sempre aprire il pannello di oRA3 usando il tasto assegnato oppure con il comando slash, per esempio |cff44ff44/radur|r."
L["unitName"] = "Nome unità"
L["unknown"] = "Sconosciuto"
L["useClassColor"] = "Usa il colore di classe"
L["whatIsThis"] = "Cos'é questo?"
L["world"] = "Reame"
L["zone"] = "Zona"
