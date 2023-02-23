import numpy as np
import pickle
import torch as th

def maple_convert(ckpt_path, out_path):
    ckpt = th.load(ckpt_path, map_location="cpu")

    if out_path.endswith("/"):
        out_path = out_path[:-1]

    # model weights
    for k, v in ckpt["state_dict"].items():
        if "first_stage_model.encoder" in k: continue
        if not hasattr(v, "numpy"): continue
        v.numpy().astype('float16').tofile(f"{out_path}/{k}.bin")

    return 0
