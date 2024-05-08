-- Copyright (C) 2021 KUMApt & Shadowskrt

Config = {}

Config.UseLanguage = "en"                                                           -- Select the language you want to use in the script (the translation is at the end of the file)
Config.UseSoundEffect = true                                                        -- Only use this if you use InteractSound

Config.Elevators = {
    -- The following tags are not required! You can add them if you want
    -- Group = "jobname" or "gangname" -> Only player with this job or gang can can go to the restricted floors
    -- Sound = "soundname" -> Use custom sound when player reaches the new floor | You can add your custom sound with .ogg extension in interactSound folder /client/html/sounds
    -- Simple example with restricted floors and custom sound
    ["holding2elevator"] = {
        -- Group = {"police", "ambulance", "lostmc"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Holding Asansör",
        Floors = {
            [1] = {
                Label = "Zemin Kat",
                FloorDesc = "Zemin kata gider",
                Restricted = true,
                Coords = vector3(-71.06, -801.01, 44.23),
                ExitHeading = "336.54"
            },
            [2] = {
                Label = "İkinci Kat",
                FloorDesc = "İkinci Kata Gider",
                Restricted = false,                                                  -- Only players with defined job (Job = "") can change to this floor
                Coords = vector3(-1577.62, -563.62, 108.52),
                ExitHeading = "69.85"
            },
            -- [3] = {
            --     Label = "Floor 1",
            --     FloorDesc = "Description for floor 1",
            --     Restricted = false,
            --     Coords = vector3(-1075.73, -252.76, 37.76),
            --     ExitHeading = "28.74"
            -- },
        }
    },
    ["holding2elevatorcati"] = {
        -- Group = {"police", "ambulance", "lostmc"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Holding Asansör",
        Floors = {
            [1] = {
                Label = "İkinci Kat",
                FloorDesc = "İkinci kata gider",
                Restricted = true,
                Coords = vector3(-1579.61, -560.88, 108.52),
                ExitHeading = "131.50"
            },
            [2] = {
                Label = "Çatı Katı",
                FloorDesc = "Çatı Katına Gider",
                Restricted = false,                                                  -- Only players with defined job (Job = "") can change to this floor
                Coords = vector3(-67.65, -821.44, 321.29),
                ExitHeading = "256.63"
            },
            -- [3] = {
            --     Label = "Floor 1",
            --     FloorDesc = "Description for floor 1",
            --     Restricted = false,
            --     Coords = vector3(-1075.73, -252.76, 37.76),
            --     ExitHeading = "28.74"
            -- },
        }
    },

    ["holdingelevator"] = {
        -- Group = {"police", "ambulance", "lostmc"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Holding Asansör",
        Floors = {
            [1] = {
                Label = "Zemin Kat",
                FloorDesc = "Zemin kata gider",
                Restricted = true,
                Coords = vector3(-589.54, -708.34, 36.28),
                ExitHeading = "4.36"
            },
            [2] = {
                Label = "İkinci Kat",
                FloorDesc = "İkinci Kata Gider",
                Restricted = false,                                                  -- Only players with defined job (Job = "") can change to this floor
                Coords = vector3(-575.36, -715.80, 113.01),
                ExitHeading = "88.98"
            },
            -- [3] = {
            --     Label = "Floor 1",
            --     FloorDesc = "Description for floor 1",
            --     Restricted = false,
            --     Coords = vector3(-1075.73, -252.76, 37.76),
            --     ExitHeading = "28.74"
            -- },
        }
    },

    ["holdingelevatorcati"] = {
        -- Group = {"police", "ambulance", "lostmc"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Holding Asansör",
        Floors = {
            [1] = {
                Label = "İkinci Kat",
                FloorDesc = "İkinci kata gider",
                Restricted = true,
                Coords = vector3(-575.07, -712.66, 113.01),
                ExitHeading = "89.66"
            },
            [2] = {
                Label = "Çatı Katı",
                FloorDesc = "Çatı Katına Gider",
                Restricted = false,                                                  -- Only players with defined job (Job = "") can change to this floor
                Coords = vector3(-579.46, -716.82, 129.98),
                ExitHeading = "92.24"
            },
            -- [3] = {
            --     Label = "Floor 1",
            --     FloorDesc = "Description for floor 1",
            --     Restricted = false,
            --     Coords = vector3(-1075.73, -252.76, 37.76),
            --     ExitHeading = "28.74"
            -- },
        }
    },
    -- Simple example without custom sound and without restricted floors
    ["gokartpist"] = {
        Name = "Elevator",
        Floors = {
            [1] = {
                Label = "Zemin Katı",
                FloorDesc = "Zemin katına gider",
                Coords = vector3(-282.40, -2031.51, 30.15),
                ExitHeading = "293.16"
            },
            [2] = {
                Label = "İkinci Kat",
                FloorDesc = "İkinci kata gider",
                Coords = vector3(5629.93, 328.93, 20.22),
                ExitHeading = "6.04"
            },
        }
    },
}

Config.Language = {
    ["en"] = {
        Elevator = "~INPUT_PICKUP~ Elevator",
        Call = "~g~E~w~ - Call Lift",
        Waiting = "Waiting for Lift...",
        Restricted = "Restricted floor!",
        CurrentFloor = "Current floor: "
    },
    ["tr"] = {
        Elevator = "~INPUT_PICKUP~ Asansör",
        Call = "~g~E~w~ - Asansörü Çağır",
        Waiting = "Asansör bekleniyor...",
        Restricted = "Sınırlı kat!",
        CurrentFloor = "Mevcut kat: "
    }
}
