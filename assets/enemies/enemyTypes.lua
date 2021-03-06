ENEMY_TYPES = {
    ["NORMAL"] = {
        health = 200,
        size = 10,
        speed = 3,
        speedRecovery = 0.5,
        minSpeed = 1,
        cost = 10,
        color = {0.1, 1, 0.1, 1},
    },
    ["FAST"] = {
        health = 150,
        size = 10,
        speed = 7,
        speedRecovery = 1.5,
        minSpeed = 3,
        cost = 20,
        color = {0.1, 1, 1, 1},
    },
    ["HEAVY"] = {
        health = 400,
        size = 13,
        speed = 1.5,
        speedRecovery = 0.5,
        minSpeed = 1,
        cost = 40,
        color = {0.4, 0.1, 0.8, 1},
    },
    ["SUPER"] = {
        health = 10000,
        size = 20,
        speed = 1,
        speedRecovery = 1,
        minSpeed = 1,
        cost = 600,
        color = {0.8, 0.4, 0.2, 1},
    },
}