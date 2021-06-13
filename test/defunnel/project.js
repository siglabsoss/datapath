module.exports = {
    "top": "project",
    "topFile": "project.v",
    "clk": "clk",
    "reset_n": "reset_n",
    "targets": [
        {
            "data": "t_1_dat",
            "valid": "t_1_req",
            "ready": "t_1_ack",
            "width": 128,
            "length": 16
        },
        {
            "data": "t_2_dat",
            "valid": "t_2_req",
            "ready": "t_2_ack",
            "width": 128,
            "length": 16
        },
        {
            "data": "t_cfg_dat",
            "valid": "t_cfg_req",
            "ready": "t_cfg_ack",
            "width": 8,
            "length": 16
        }
    ],
    "initiators": [
        {
            "data": "i_4_dat",
            "valid": "i_4_req",
            "ready": "i_4_ack",
            "width": 512,
            "length": 16
        }
    ]
};