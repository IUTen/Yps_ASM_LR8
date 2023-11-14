format MZ
entry code_segment:main
stack 200h
;---------------------------
segment data_seg

notes db 128 dup(?)

;---------------------------
segment code_segment

main:
    jmp _init
    end_init:


    mov cx, 28
    melody:
        mov ax, word[es:di]
        add di, 2
        call play_note
        call timeout_small

        loop melody


    jmp end_running

;=====================Основные функции=====================

play_note:                              ;В АХ должно лежать значение ноты
    pusha

    out 0x42, al                        ;Загружаем в порт ноту
    mov al, ah
    out 0x42, al

    in al, 0x61                         ;Включаем звук
    or al, 0011b
    out 0x61, al

    call timeout                        ;Продлеваем звук

    in al, 0x61                         ;Выключаем звук
    and al, 11111100b
    out 0x61, al

    popa
    ret

;===================Вспомогательный блок===================

;Инициализация нот для воспроизведения.
_init:
    pusha

    mov ax, data_seg                    ;Сегмент и смещение
    mov es, ax
    mov di, notes                       ;буфера с нотами

    mov word[es:di], (1190000/262)      ;До, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/392)      ;Соль, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/349)      ;Фа, первая октава
    add di, 2
    mov word[es:di], (1190000/262)      ;До, первая октава
    add di, 2
    mov word[es:di], (1190000/262)      ;До, первая октава
    add di, 2
    mov word[es:di], (1190000/262)      ;До, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/466)      ;Ля-си, первая октава
    add di, 2
    mov word[es:di], (1190000/392)      ;Соль, первая октава
    add di, 2
    mov word[es:di], (1190000/523)      ;До, вторая октава
    add di, 2
    mov word[es:di], (1190000/523)      ;До, вторая октава
    add di, 2
    mov word[es:di], (1190000/294)      ;Ре, первая октава
    add di, 2
    mov word[es:di], (1190000/294)      ;Ре, первая октава
    add di, 2
    mov word[es:di], (1190000/466)      ;Ля-си, первая октава
    add di, 2
    mov word[es:di], (1190000/466)      ;Ля-си, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/392)      ;Соль, первая октава
    add di, 2
    mov word[es:di], (1190000/349)      ;Фа, первая октава
    add di, 2
    mov word[es:di], (1190000/349)      ;Фа, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/392)      ;Соль, первая октава
    add di, 2
    mov word[es:di], (1190000/440)      ;Ля, первая октава
    add di, 2
    mov word[es:di], (1190000/349)      ;Фа, первая октава

    popa

    mov ax, data_seg                    ;Сегмент и смещение массива нот
    mov es, ax
    mov di, notes

    jmp end_init

timeout:                ;Задержка в тиках
    pusha

    xor ah,ah           ;Обнуляем ah
    int 1ah             ;Читаем часы

    add dx, 8           ;Добавили к прочитанному времени задержку
    mov bx, dx          ;Записали в BX время начала задержки + задержку
    .wait:
    int 1ah             ;Читаем часы
    cmp dx, bx          ;Сравниваем нынешнее время с необходимым 
    jl .wait

    popa
    ret 

timeout_small:                ;Задержка в тиках
    pusha

    xor ah,ah           ;Обнуляем ah
    int 1ah             ;Читаем часы

    add dx, 1           ;Добавили к прочитанному времени задержку
    mov bx, dx          ;Записали в BX время начала задержки + задержку
    .wait:
    int 1ah             ;Читаем часы
    cmp dx, bx          ;Сравниваем нынешнее время с необходимым 
    jl .wait

    popa
    ret 

end_running:
    xor ax, ax
    int 0x16
    mov ax, 0x4C00
    int 0x21

test_jm:
    jmp end_init
