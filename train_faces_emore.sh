#!/bin/bash

export CUDA_VISIBLE_DEVICES=0,1,2,3

# --num_class 10575 \
    # --boundaries '10,16,19' \
phrase="finetune"

model="mobilenetv2_dw"
n_gpu=4
lr_scale=0.1

if [ "$phrase" = "train" ]; then
    nohup python train.py \
        --restore './log/resnet_456_s_fe/resnet_456_s_8-325980' \
        --finetune '' \
        --dataset_root ./data/faces_emore \
        --logdir log/resnet_456_s_fe \
        --num_class 85742 \
        --log_every 200 \
        --start_epoch 9 \
        --end_epoch 14 \
        --model resnet_456_s \
        --batch_size 40 \
        --weight_decay 1e-4 \
        --values '1e-1,1e-2,1e-3,1e-4' \
        --boundaries '9,12,13' \
        --lr_scale 1 \
        --pre_lr_scale 1 \
        --s 64 \
        --m 0.5 \
        --train_model True \
        --load_fc False \
        --n_epoch_softmax 4 \
        --n_gpu 4 |& tee tmp.log &
elif [ "$phrase" = "finetune" ]; then
    nohup python train.py \
        --restore '' \
        --finetune 'log/resnet_456_s_fe/resnet_456_s_13-507080' \
        --dataset_root ./data/ms-id-40w-aug \
        --model resnet_456_s \
        --logdir log/resnet_456_s_fe_ms_id40w_aug_ft_v2 \
        --num_class 482564 \
        --log_every 200 \
        --start_epoch 0 \
        --end_epoch 6 \
        --batch_size 40 \
        --weight_decay 1e-4 \
        --values '1e-1,1e-2,1e-3,1e-4' \
        --boundaries '2,4,5' \
        --lr_scale 0.1 \
        --pre_lr_scale 1 \
        --s 64 \
        --m 0.5 \
        --train_model True \
        --n_epoch_softmax 0 \
        --n_gpu "$n_gpu" |& tee tmp.log &
fi
