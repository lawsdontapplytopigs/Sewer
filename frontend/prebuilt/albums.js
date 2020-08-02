
let albumDir = "https://cdn.jsdelivr.net/gh/lawsdontapplytopigs/Sewer@216847003787a6e09fb0c1856c6dee24d18f23cb/frontend/prebuilt/albums/";
let makeURI = ( album_name ) => ( song_name ) => {
    return "https://cdn.jsdelivr.net/gh/lawsdontapplytopigs/Sewer@216847003787a6e09fb0c1856c6dee24d18f23cb/frontend/prebuilt/albums/" + album_name + "/"+ song_name + ".mp3"
};

console.log( albumDir + "irly-ep/cover.jpg")

let irlyEPURI = makeURI("irly-ep")
let irlyEP = {
    title : "IRLY - EP",
    albumCoverSrc : albumDir + "irly-ep/cover.jpg",
    songs : [
        {
            title : "Kawaii Razor Blades (feat. yandere)",
            artist : "Sewerslvt",
            duration : 338,
            src : irlyEPURI("kawaii-razor-blades-feat-yandere")
        },
        {
            title : "Euphoric Filth (Cheru's Theme)",
            artist : "Sewerslvt",
            duration : 246,
            src : irlyEPURI("euphoric-filth-cherus-theme")
        },
        {
            title : "Dysphoria",
            artist : "Sewerslvt",
            duration : 286,
            src : irlyEPURI("dysphoria")
        },
        {
            title : "I Really Like You pt1",
            artist : "Sewerslvt",
            duration : 373,
            src : irlyEPURI("i-really-like-you-pt1")
        }
    ]
};

let drainingLoveStoryURI = makeURI("draining-love-story");
let drainingLoveStory = {
    title : "Draining Love Story",
    albumCoverSrc : albumDir + "draining-love-story/cover.jpg",
    songs : [
        {
            title : "Love Is A Mighty Big Word",
            artist : "Sewerslvt",
            duration : 131,
            src : drainingLoveStoryURI("love-is-a-mighty-big-word")
        },
        {
            title : "Newlove",
            artist : "Sewerslvt",
            duration : 359,
            src : drainingLoveStoryURI("newlove")
        },
        {
            title : "Yandere Complex",
            artist : "Sewerslvt",
            duration: 250,
            src : drainingLoveStoryURI("yandere-complex")
        },
        {
            title : "Ecifircas",
            artist : "Sewerslvt",
            duration: 347,
            src : drainingLoveStoryURI("ecifircas")
        },
        {
            title : "Lexapro Delirium",
            artist : "Sewerslvt",
            duration: 435,
            src : drainingLoveStoryURI("lexapro-delirium")
        },
        {
            title : "This Fleeting Feeling",
            artist : "Sewerslvt",
            duration: 211,
            src : drainingLoveStoryURI("this-fleeting-feeling")
        },
        {
            title : "Swinging In His Cell",
            artist : "Sewerslvt",
            duration: 322,
            src : drainingLoveStoryURI("swinging-in-his-cell")
        },
        {
            title : "Mr. Kill Myself",
            artist : "Sewerslvt",
            duration: 471,
            src : drainingLoveStoryURI("mr-kill-myself")
        },
        {
            title : "Down The Drain (feat. Nurtheon)",
            artist : "Sewerslvt",
            duration: 488,
            src : drainingLoveStoryURI("down-the-drain")
        },
        {
            title : "Slowdeath",
            artist : "Sewerslvt",
            duration: 492,
            src : drainingLoveStoryURI("slowdeath")
        },
    ]
};

let drowningInTheSewerURI = makeURI("drowning-in-the-sewer");
let drowningInTheSewer = {
    title : "Drowning In The Sewer",
    albumCoverSrc : albumDir + "drowning-in-the-sewer/cover.jpg",
    songs : [ 
        {
            title : "RSOD",
            artist : "Sewerslvt",
            duration : 240,
            src : drowningInTheSewerURI("rsod"),
        },
        {
            title : "Cyberia lyr1",
            artist : "Sewerslvt",
            duration : 294,
            src : drowningInTheSewerURI("cyberia-lyr1")
        },
        {
            title : "Luciferians",
            artist : "Sewerslvt",
            duration : 288,
            src : drowningInTheSewerURI("luciferians")
        },
        {
            title : "Squids",
            artist : "Sewerslvt",
            duration : 344,
            src : drowningInTheSewerURI("squids")
        },
        {
            title : "Hopelessness",
            artist : "Sewerslvt",
            duration : 291,
            src : drowningInTheSewerURI("hopelessness")
        },
        {
            title : "Suicide In Fragments",
            artist : "Sewerslvt",
            duration : 261,
            src : drowningInTheSewerURI("suicide-in-fragments")
        },
        {
            title : "Nice Ways To Die",
            artist : "Sewerslvt",
            duration : 349,
            src : drowningInTheSewerURI("nice-ways-to-die")
        },
        {
            title : "Cyberia lyr2",
            artist : "Sewerslvt",
            duration : 245,
            src : drowningInTheSewerURI("cyberia-lyr2")
        },
        {
            title : "Blacklight (feat. Skvlls)",
            artist : "Sewerslvt",
            duration : 277,
            src : drowningInTheSewerURI("blacklight-feat-skvlls")
        },
        {
            title : "Junko Loves You",
            artist : "Sewerslvt",
            duration : 408,
            src : drowningInTheSewerURI("junko-loves-you")
        },
        {
            title : "Lolibox",
            artist : "Sewerslvt",
            duration : 510,
            src : drowningInTheSewerURI("lolibox")
        },
        {
            title : "177013",
            artist : "Sewerslvt",
            duration : 176,
            src : drowningInTheSewerURI("177013")
        },
        {
            title : "Death & Humanity",
            artist : "Sewerslvt",
            duration : 480,
            src : drowningInTheSewerURI("death-and-humanity")
        },
        {
            title : "Nothingness",
            artist : "Sewerslvt",
            duration : 951,
            src : drowningInTheSewerURI("nothingness")
        }
    ],
};

let selectedSewerWorksURI = makeURI("selected-sewer-works-2017-19");
let selectedSewerWorks = {
    title : "Selected Sewer Works (2017-19)",
    albumCoverSrc : albumDir + "selected-sewer-works-2017-19/cover.jpg",
    songs : [
        {
            title : "Junko's Theme",
            artist : "Sewerslvt",
            duration : 132,
            src : selectedSewerWorksURI("junkos-theme")
        },
        {
            title : "Was It Weird I Listened To \"Im God\" By Clams Casino's When I Lost My Virginity",
            artist : "Sewerslvt",
            duration : 378,
            src : selectedSewerWorksURI("was-it-weird-i-listened-to-im-god-by-clams-casinos-when-i-lost-my-virginity")
        },
        {
            title : "Personal Purgatory",
            artist : "Sewerslvt",
            duration : 178,
            src : selectedSewerWorksURI("personal-purgatory")
        },
        {
            title : "Rapescape",
            artist : "Sewerslvt",
            duration : 234,
            src : selectedSewerWorksURI("rapescape"),
        },
        {
            title : "The Grilled Fish's Ballad",
            artist : "Sewerslvt",
            duration : 491,
            src : selectedSewerWorksURI("the-grilled-fishs-ballad")
        },
        {
            title : "Pemex (Sewerslvt Remix)",
            artist : "Fat Nick & Shakewell",
            duration : 174,
            src : selectedSewerWorksURI("fat-nick-and-shakewell-pemex-sewerslvt-remix")
        },
        {
            title : "Japanese Electronics (Sewerslvt Flip)",
            artist : "Commix & Instra:Mental Moog",
            duration : 340,
            src : selectedSewerWorksURI("commix-and-instra-mental-moog-japanese-electronics-sewerslvt-flip")
        },
        {
            title : "Pandora's Box (VIP)",
            artist : "Sewerslvt",
            duration : 307,
            src : selectedSewerWorksURI("pandoras-box-vip")
        },
        {
            title : "Obedient (Sewerslvt Remix)",
            artist : "Bladee",
            duration : 231,
            src : selectedSewerWorksURI("bladee-obedient-sewerslvt-remix")
        },
        {
            title : "Drowning",
            artist : "Sewerslvt",
            duration : 142,
            src : selectedSewerWorksURI("drowning")
        },
    ],
};

let starvingSlvtsAlwaysGetTheirFixURI = makeURI("starving-slvts-always-get-their-fix");
let starvingSlvtsAlwaysGetTheirFix = {
    title : "Starving Slvts Always Get Their Fix",
    albumCoverSrc : albumDir + "starving-slvts-always-get-their-fix/cover.jpg",
    songs : [
        {
            title : "Starving Slvt Overture",
            artist : "Sewerslvt",
            duration : 453,
            src : starvingSlvtsAlwaysGetTheirFixURI("starving-slvt-overture")
        },
        {
            title : "Little Ones",
            artist : "Sewerslvt",
            duration : 204,
            src : starvingSlvtsAlwaysGetTheirFixURI("little-ones")
        },
        {
            title : "Cold Steel",
            artist : "Sewerslvt",
            duration : 208,
            src : starvingSlvtsAlwaysGetTheirFixURI("cold-steel")
        },
        {
            title : "Lips",
            artist : "Sewerslvt",
            duration : 159,
            src : starvingSlvtsAlwaysGetTheirFixURI("lips")
        },
        {
            title : "Nowhere Past Oblivion",
            artist : "Sewerslvt",
            duration : 149,
            src : starvingSlvtsAlwaysGetTheirFixURI("nowhere-past-oblivion")
        },
        {
            title : "Pandora's Box",
            artist : "Sewerslvt",
            duration : 345,
            src : starvingSlvtsAlwaysGetTheirFixURI("pandoras-box")
        },
        {
            title : "Private Life",
            artist : "Sewerslvt",
            duration : 132,
            src : starvingSlvtsAlwaysGetTheirFixURI("private-life")
        },
        {
            title : "The Maw",
            artist : "Sewerslvt",
            duration : 168,
            src : starvingSlvtsAlwaysGetTheirFixURI("the-maw")
        },
        {
            title : "Dopamine Rush",
            artist : "Sewerslvt",
            duration : 438,
            src : starvingSlvtsAlwaysGetTheirFixURI("dopamine-rush")
        },
        {
            title : "Witness The Death",
            artist : "Sewerslvt",
            duration : 474,
            src : starvingSlvtsAlwaysGetTheirFixURI("witness-the-death")
        },
    ],
};

let sewerSlvtEPURI = makeURI("sewer-slvt-ep");
let sewerSlvtEP = {
    title : "Sewer//Slvt - EP",
    albumCoverSrc : albumDir + "sewer-slvt-ep/cover.jpg",
    songs : [
        {
            title : "Sewer",
            artist : "Sewerslvt",
            duration : 270,
            src : sewerSlvtEPURI("sewer")
        },
        {
            title : "Sanae (Unending Status Quo)",
            artist : "Sewerslvt",
            duration : 257,
            src : sewerSlvtEPURI("sanae-unending-status-quo")
        },
        {
            title : "Cute Panties Soaked In Arizona Iced Tea",
            artist : "Sewerslvt",
            duration : 178,
            src : sewerSlvtEPURI("cute-panties-soaked-in-arizona-iced-tea")
        },
        {
            title : "Pretty Cvnt",
            artist : "Sewerslvt",
            duration : 220,
            src : sewerSlvtEPURI("pretty-cvnt")
        },
        {
            title : "Doin' It Right (Sewerslvt Remix)",
            artist : "Daft Punk",
            duration : 394,
            src : sewerSlvtEPURI("daft-punk-doin-it-right-sewerslvt-remix")
        },
        {
            title : "I Love It When You Suffer",
            artist : "Sewerslvt",
            duration : 237,
            src : sewerSlvtEPURI("i-love-it-when-you-suffer")
        },
        {
            title : "Oni",
            artist : "Sewerslvt",
            duration : 363,
            src : sewerSlvtEPURI("oni")
        },
        {
            title : "NTR Ending (Cardiac Arrest Due To Overdose)",
            artist : "Sewerslvt",
            duration : 202,
            src : sewerSlvtEPURI("ntr-ending-cardiac-arrest-due-to-overdose")
        },
        {
            title : "Catharsis",
            artist : "Sewerslvt",
            duration : 414,
            src : sewerSlvtEPURI("catharsis")
        },
        {
            title : "Slvt",
            artist : "Sewerslvt",
            duration : 184,
            src : sewerSlvtEPURI("slvt")
        },
    ],
};

let sewerIdolProjectURI = makeURI("sewer-idol-project");
let sewerIdolProject = {
    title : "Sewer Idol Project",
    albumCoverSrc : albumDir + "sewer-idol-project/cover.jpg",
    songs : [
        {
            title : "Doin' It Right (Sewerslvt Remix)",
            artist : "Daft Punk",
            duration : 394,
            src : sewerIdolProjectURI("daft-punk-doin-it-right-sewerslvt-remix")
        },
        {
            title : "Was It Weird I Listened To \"Im God\" By Clams Casino's When I Lost My Virginity",
            artist : "Sewerslvt",
            duration : 378,
            src : sewerIdolProjectURI("was-it-weird-i-listened-to-im-god-by-clams-casinos-when-i-lost-my-virginity")
        },
        {
            title : "Pemex (Sewerslvt Remix)",
            artist : "Fat Nick & Shakewell",
            duration : 174,
            src : sewerIdolProjectURI("fat-nick-and-shakewell-pemex-sewerslvt-remix")
        },
        {
            title : "Japanese Electronics (Sewerslvt Flip)",
            artist : "Commix & Instra:Mental Moog",
            duration : 340,
            src : sewerIdolProjectURI("commix-and-instra-mental-moog-japanese-electronics-sewerslvt-flip")
        },
        {
            title : "Pandora's Box (VIP)",
            artist : "Sewerslvt",
            duration : 307,
            src : sewerIdolProjectURI("pandoras-box-vip")
        },
        {
            title : "Obedient (Sewerslvt Remix)",
            artist : "Bladee",
            duration : 231,
            src : sewerIdolProjectURI("bladee-obedient-sewerslvt-remix")
        },
        {
            title : "In The Distant Travels (Sewerslvt Remix)",
            artist : "Sadness",
            duration : 544,
            src : sewerIdolProjectURI("sadness-in-the-distant-travels-sewerslvt-remix")
        },
        {
            title : "Hoover (Sewerslvt Remix)",
            artist : "Yung Lean",
            duration : 237,
            src : sewerIdolProjectURI("yung-lean-hoover-sewerslvt-remix")
        },
        {
            title : "37564 (Sewerslvt Remix)",
            artist : "Foxxy Dekay & 4649nadeshiko",
            duration : 162,
            src : sewerIdolProjectURI("foxxy-dekay-and-4649nadeshiko-37564-sewerslvt-remix")
        },
        {
            title : "Get Your Wish (Sewerslvt Remix)",
            artist : "Porter Robinson",
            duration : 252,
            src : sewerIdolProjectURI("porter-robinson-get-your-wish-sewerslvt-remix")
        },
        {
            title : " 卒業ですね (Sewerslvt Remix)",
            artist : "AZALEA",
            duration : 267,
            src : sewerIdolProjectURI("azalea-sewerslvt-remix")
        },
        {
            title : "Drown (Sewerslvt Remix)",
            artist : "Bring Me The Horizon",
            duration : 496,
            src : sewerIdolProjectURI("bring-me-the-horizon-drown-sewerslvt-remix")
        },
        {
            title : "Never Meant (Sewerslvt & Sadfem Remix)",
            artist : "American Football",
            duration : 303,
            src : sewerIdolProjectURI("american-football-never-meant-sewerslvt-and-sadfem-remix")
        },
        {
            title : "Satellite (Sewerslvt Edit)",
            artist : "Oceanlab",
            duration : 169,
            src : sewerIdolProjectURI("oceanlab-satellite-sewerslvt-edit")
        },
        {
            title : "Yandere Complex (VIP)",
            artist : "Sewerslvt",
            duration : 185,
            src : sewerIdolProjectURI("yandere-complex-vip")
        },
        {
            title : "Purple Emotion (Sewerslvt Happy Hardcore Edit)",
            artist : "Go2",
            duration : 324,
            src : sewerIdolProjectURI("go2-purple-emotion-sewerslvt-happy-hardcore-edit")
        },
    ]
};

let itJustGetsWorseURI = makeURI("it-just-gets-worse");
let itJustGetsWorse = {
    title : "It Just Gets Worse",
    albumCoverSrc : albumDir + "it-just-gets-worse/cover.jpg",
    songs : [
        {
            title : "intro [this is very bad and im gay]",
            artist : "Sewerslvt & Mortem",
            duration : 90,
            src : itJustGetsWorseURI("intro-w-mortem-this-is-very-bad-and-im-gay")
        },
        {
            title : "ski mask fuck",
            artist : "Sewerslvt",
            duration : 128,
            src : itJustGetsWorseURI("ski-mask-fuck")
        },
        {
            title : "toe wizard",
            artist : "Sewerslvt & Mortem",
            duration : 207,
            src : itJustGetsWorseURI("toe-wizard-w-mortem")
        },
        {
            title : "drunk is nature",
            artist : "Sewerslvt",
            duration : 168,
            src : itJustGetsWorseURI("drunk-is-nature")
        },
        {
            title : "ru3",
            artist : "Sewerslvt & Mortem",
            duration : 178,
            src : itJustGetsWorseURI("ru3-w-mortem")
        },
        {
            title : "sleep in it you swine",
            artist : "Sewerslvt",
            duration : 194,
            src : itJustGetsWorseURI("sleep-in-it-you-swine")
        },
        {
            title : "vapor trail pt1",
            artist : "Sewerslvt & Mortem",
            duration : 211,
            src : itJustGetsWorseURI("vapor-trail-pt1-w-mortem")
        },
        {
            title : "vapor trail pt2",
            artist : "Sewerslvt & Mortem",
            duration : 196,
            src : itJustGetsWorseURI("vapor-trail-pt2-w-mortem")
        },
        {
            title : "nedrag maets",
            artist : "Sewerslvt",
            duration : 180,
            src : itJustGetsWorseURI("nedrag-maets")
        },
        {
            title : "tuentin qarantino",
            artist : "Sewerslvt & Mortem",
            duration : 146,
            src : itJustGetsWorseURI("tuentin-qarantino")
        },
        {
            title : "end",
            artist : "Sewerslvt",
            duration : 330,
            src : itJustGetsWorseURI("end")
        },
    ],
};

let dontBeAfraidOfDyingURI = makeURI("dont-be-afraid-of-dying");
let dontBeAfraidOfDying = {
    title : "Don't Be Afraid Of Dying",
    albumCoverSrc : albumDir + "dont-be-afraid-of-dying/cover.jpg",
    songs : [
        {
            title : "J.ust keeps getting worse doesn't it? [introshit]",
            artist : "Sewerslvt",
            duration : 80,
            src : dontBeAfraidOfDyingURI("j-ust-keeps-getting-worse-doesnt-it-introshit")
        },
        {
            title : "U.nfortunate, but what can you do about It [gin$engtrillshit]",
            artist : "Sewerslvt",
            duration : 166,
            src : dontBeAfraidOfDyingURI("u-nfortunate-but-what-can-you-do-about-it-ginsengtrillshit")
        },
        {
            title : "N.ecrophilia: it applies to the dead inside now [lorncloudshit]",
            artist : "Sewerslvt",
            duration : 252,
            src : dontBeAfraidOfDyingURI("n-ecrophilia-it-applies-to-the-dead-inside-now-lorn-cloud-shit")
        },
        {
            title : "K.illing time for the fuck of it [emoguitarshit]",
            artist : "Sewerslvt",
            duration : 164,
            src : dontBeAfraidOfDyingURI("k-illing-time-for-the-fuck-of-it-emoguitarshit"),
        },
        {
            title : "O.f coarse, it's the worlds fault i'm fucked up [vestigeiiphonkshit]",
            artist : "Sewerslvt",
            duration : 168,
            src : dontBeAfraidOfDyingURI("o-f-coarse-its-the-worlds-fault-im-fucked-up")
        },
        {
            title : "F.ourty four days in hell & back [desolationwitchshit]",
            artist : "Sewerslvt",
            duration : 141,
            src : dontBeAfraidOfDyingURI("f-ourty-four-days-in-hell-and-back-desolationwitchshit")
        },
        {
            title : "U.nder the weight of a thousand demons [crycaswitchshit]",
            artist : "Sewerslvt",
            duration : 118,
            src : dontBeAfraidOfDyingURI("u-nder-the-weight-of-a-thousand-demons-crycaswitchshit")
        },
        {
            title : "R.ecalling how to control myself [opnlofishit]",
            artist : "Sewerslvt",
            duration : 275,
            src : dontBeAfraidOfDyingURI("r-ecalling-how-to-control-myself-opnlofishit")
        },
        {
            title : "U.nderneath this skin of ours lies true humanity [ambienterlude]",
            artist : "Sewerslvt",
            duration : 192,
            src : dontBeAfraidOfDyingURI("u-nderneath-this-skin-of-ours-lies-true-humanity-ambienterlude")
        },
        {
            title : "T.his is war [girlslasttourshit]",
            artist : "Sewerslvt",
            duration : 178,
            src : dontBeAfraidOfDyingURI("t-his-is-war-girlslasttourshit")
        },
        {
            title : "A.nd now... [brokenoutroshit]",
            artist : "Sewerslvt",
            duration : 178,
            src : dontBeAfraidOfDyingURI("a-nd-now-brokenoutroshit")
        },
    ]
};

window.SewerslvtAlbums = [
    irlyEP,
    drainingLoveStory,
    drowningInTheSewer,
    selectedSewerWorks,
    starvingSlvtsAlwaysGetTheirFix,
    sewerSlvtEP,
    sewerIdolProject,
    itJustGetsWorse,
    dontBeAfraidOfDying
];

/* module.exports = { */
/*     albums : [ */
/*         irlyEP, */
/*         drainingLoveStory, */
/*         drowningInTheSewer, */
/*         selectedSewerWorks, */
/*         starvingSlvtsAlwaysGetTheirFix, */
/*         sewerSlvtEP, */
/*         sewerIdolProject, */
/*         itJustGetsWorse, */
/*         dontBeAfraidOfDying */
/*     ] */
/* }; */
