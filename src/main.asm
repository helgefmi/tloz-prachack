arch nes.cpu
header

banksize $4000

incsrc "defines.asm"


// Overwriting:
// $E4C1  20 80 A0  JSR $A080
bank 7
org $E4C1
  // We're in Bank 6 at this moment
  JSR send_current_ppu_command_hook


bank 6
org $B000
send_current_ppu_command_hook:
    JSR $A080 // Call the original routine

    JSR update_timer
    JSR check_for_transision

    LDA {consecutive_kills} ; CMP {cache_consecutive_kills} ; BNE .draw_counters
    LDA {consecutive_10_kills} ; CMP {cache_consecutive_10_kills} ; BNE .draw_counters
    LDA {drop_counter} ; CMP {cache_drop_counter} ; BNE .draw_counters

    JMP .end

  .draw_counters:
    LDA {consecutive_kills} ; STA {cache_consecutive_kills}
    LDA {consecutive_10_kills} ; STA {cache_consecutive_10_kills}
    LDA {drop_counter} ; STA {cache_drop_counter}

    JSR hud_draw_counters

  .end:
    RTS


update_timer:
    INC {timer_frames}
    LDA {timer_frames} ; CMP #60 ; BNE .done

    LDA #$00 ; STA {timer_frames}
    INC {timer_secs}
  .done:
    RTS


check_for_transision:
    LDA {game_mode} ; CMP {cache_game_mode} ; BEQ .done
    STA {cache_game_mode}

    CMP #$07 ; BEQ .transition_occured
    CMP #$0A ; BEQ .transition_occured
    CMP #$10 ; BEQ .transition_occured

    JMP .done

  .transition_occured:
    LDA {timer_frames} ; STA {last_timer_frames}
    LDA {timer_secs} ; STA {last_timer_secs}
    LDA #$00 ; STA {timer_frames} ; STA {timer_secs}
    JSR hud_draw_timer

  .done:
    RTS


hud_draw_timer:
    LDA $FF ; AND #$FB ; STA $2000

    LDA #$20 ; STA $2006 ; LDA #$42 ; STA $2006
    LDX {last_timer_secs}
    LDA cache_tens,x ; STA $2007
    LDA cache_ones,x ; STA $2007
    LDA #$2A ; STA $2007

    LDX {last_timer_frames}
    LDA cache_tens,x ; STA $2007
    LDA cache_ones,x ; STA $2007

    LDA #$24 ; STA $2007
    LDA #$24 ; STA $2007

    LDA $FF ; STA $2000
    RTS


hud_draw_counters:
    LDA $FF ; AND #$FB ; STA $2000

    LDA #$20 ; STA $2006 ; LDA #$4E ; STA $2006
    LDX {consecutive_kills}
    LDA cache_tens,x ; STA $2007
    LDA cache_ones,x ; STA $2007

    LDA #$24 ; STA $2007

    LDX {consecutive_10_kills}
    LDA cache_tens,x ; STA $2007
    LDA cache_ones,x ; STA $2007

    LDA #$24 ; STA $2007

    LDX {drop_counter}
    LDA cache_tens,x ; STA $2007
    LDA cache_ones,x ; STA $2007

    LDA $FF ; STA $2000
    RTS

warnpc $BD40

org $BD40
cache_tens:
    db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 0
    db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 10
    db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 20
    db $3,$3,$3,$3,$3,$3,$3,$3,$3,$3 // 30
    db $4,$4,$4,$4,$4,$4,$4,$4,$4,$4 // 40
    db $5,$5,$5,$5,$5,$5,$5,$5,$5,$5 // 50
    db $6,$6,$6,$6,$6,$6,$6,$6,$6,$6 // 60
    db $7,$7,$7,$7,$7,$7,$7,$7,$7,$7 // 70
    db $8,$8,$8,$8,$8,$8,$8,$8,$8,$8 // 80
    db $9,$9,$9,$9,$9,$9,$9,$9,$9,$9 // 90
    db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 0
    db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 10
    db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 20
    db $3,$3,$3,$3,$3,$3,$3,$3,$3,$3 // 30
    db $4,$4,$4,$4,$4,$4,$4,$4,$4,$4 // 40
    db $5,$5,$5,$5,$5,$5,$5,$5,$5,$5 // 50
    db $6,$6,$6,$6,$6,$6,$6,$6,$6,$6 // 60
    db $7,$7,$7,$7,$7,$7,$7,$7,$7,$7 // 70
    db $8,$8,$8,$8,$8,$8,$8,$8,$8,$8 // 80
    db $9,$9,$9,$9,$9,$9,$9,$9,$9,$9 // 90
    db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0 // 0
    db $1,$1,$1,$1,$1,$1,$1,$1,$1,$1 // 10
    db $2,$2,$2,$2,$2,$2,$2,$2,$2,$2 // 20
    db $3,$3,$3,$3,$3,$3,$3,$3,$3,$3 // 30
    db $4,$4,$4,$4,$4,$4,$4,$4,$4,$4 // 40
    db $5,$5,$5,$5,$5,$5             // 50
warnpc $BE41

org $BE40
cache_ones:
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 0
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 10
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 20
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 30
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 40
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 50
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 60
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 70
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 80
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 90
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 100
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 110
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 120
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 130
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 140
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 150
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 160
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 170
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 180
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 190
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 200
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 210
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 220
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 230
    db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9 // 240
    db $0,$1,$2,$3,$4,$5             // 250
warnpc $BF41
