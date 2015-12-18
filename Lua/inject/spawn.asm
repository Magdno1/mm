[actor_spawn]: 0x800BAE14
[max_actor_no]: 0x2B1

[global_context]: 0x803E6B20
[buttons_offset]: 0x14
[actor_spawn_offset]: 0x1CA0

[link_actor]: 0x803FFDB0
[actor_x]: 0x24
[actor_y]: 0x28
[actor_z]: 0x2C

[link_save]: 0x801EF670
[rupees_offset]: 0x3A
[upgrades_offset]: 0xB8
[upgrades_2_offset]: 0xBA

[button_L]: 0x0020
[button_D_right]: 0x0100
[button_D_left]: 0x0200
[button_D_down]: 0x0400
[button_D_up]: 0x0800

        push    4, ra
        li      t0, @link_save
        li      t1, @global_context
// give max rupee upgrade (set bit 13, clear bit 12 of lower halfword)
        lh      t2, @upgrades_2_offset(t0)
        ori     t2, t2, 0x2000
        andi    t2, t2, 0xEFFF
        sh      t2, @upgrades_2_offset(t0)
//
        lhu     t2, @buttons_offset(t1)
        lh      t9, @rupees_offset(t0)
        andi    t3, t2, @button_D_up
        beq     t3, r0, no_D_up
        nop
        addi    t9, t9, 1
no_D_up:
        andi    t3, t2, @button_D_down
        beq     t3, r0, no_D_down
        nop
        subi    t9, t9, 1
no_D_down:
        andi    t3, t2, @button_D_right
        beq     t3, r0, no_D_right
        nop
        addi    t9, t9, 10
no_D_right:
        andi    t3, t2, @button_D_left
        beq     t3, r0, no_D_left
        nop
        subi    t9, t9, 10
no_D_left:
        subi    t4, t9, 1
        bgez    t4, no_min
        nop
        li      t9, @max_actor_no
no_min:
        subi    t4, t9, @max_actor_no
        blez    t4, no_max
        nop
        li      t9, 1
no_max:
        sh      t9, @rupees_offset(t0)
        andi    t3, t2, @button_L
        beq     t3, r0, return
        nop
        mov     a0, t9
        bal     simple_spawn
        nop
return:
        jpop    4, ra

simple_spawn: // args: a0 (actor to spawn)
        push    4, 9, ra
        mov     a2, a0
        li      a1, @global_context
        addi    a0, a1, @actor_spawn_offset
        li      t0, @link_actor
        lw      t1, @actor_x(t0)
        lw      t2, @actor_y(t0)
        lw      t3, @actor_z(t0)
        mov     a3, t1 // X position
        sw      t2, 0x10(sp) // Y position
        sw      t3, 0x14(sp) // Z position
        sw      r0, 0x18(sp) // rotation?
        sw      r0, 0x1C(sp) // rotation?
        sw      r0, 0x20(sp) // rotation?
        sw      r0, 0x24(sp) // object number?
        li      t9, 0x0000007F
        sw      t9, 0x28(sp) // unknown
        li      t9, 0x000003FF
        sw      t9, 0x2C(sp) // unknown
        sw      r0, 0x30(sp) // unknown
        // and finally..
        jal     @actor_spawn
        nop
        jpop    4, 9, ra
