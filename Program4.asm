;***********************************************************
; Programming Assignment 4
; Student Name: Desheng Liu 
; UT Eid: dl36526
; -------------------Save Simba (Part II)---------------------
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

;***********************************************************

.ORIG x4000

;***********************************************************
; Main Program
;***********************************************************
        JSR   DISPLAY_JUNGLE
        LEA   R0, JUNGLE_INITIAL
        TRAP  x22 
        LDI   R0,BLOCKS
        JSR   LOAD_JUNGLE
        JSR   DISPLAY_JUNGLE
        LEA   R0, JUNGLE_LOADED
        TRAP  x22                        ; output end message
HOMEBOUND
        LEA   R0,PROMPT
        TRAP  x22
        TRAP  x20                        ; get a character from keyboard into R0
        TRAP  x21                        ; echo character entered
        LD    R3, ASCII_Q_COMPLEMENT     ; load the 2's complement of ASCII 'Q'
        ADD   R3, R0, R3                 ; compare the first character with 'Q'
        BRz   EXIT                       ; if input was 'Q', exit
;; call a converter to convert i,j,k,l to up(0) left(1),down(2),right(3) respectively
        JSR   IS_INPUT_VALID      
        ADD   R2, R2, #0                 ; R2 will be zero if the move was valid
        BRz   VALID_INPUT
        LEA   R0, INVALID_MOVE_STRING    ; if the input was invalid, output corresponding
        TRAP  x22                        ; message and go back to prompt
        BR    HOMEBOUND
VALID_INPUT 
        JSR   APPLY_MOVE                 ; apply the move (Input in R0)
        JSR   DISPLAY_JUNGLE
        JSR   IS_SIMBA_HOME      
        ADD   R2, R2, #0                 ; R2 will be zero if Simba reached Home
        BRnp  HOMEBOUND                     ; otherwise, loop back
EXIT   
        LEA   R0, GOODBYE_STRING
        TRAP  x22                        ; output a goodbye message
        TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
ASCII_Q_COMPLEMENT  .FILL    x-71    ; two's complement of ASCII code for 'q'
PROMPT .STRINGZ "\nEnter Move \n\t(up(i) left(j),down(k),right(l)): "
INVALID_MOVE_STRING .STRINGZ "\nInvalid Input (ijkl)\n"
GOODBYE_STRING      .STRINGZ "\nYou Saved Simba !Goodbye!\n"
BLOCKS               .FILL x5000

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
  
;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE      
; Your Program 3 code goes here
;save all previous contents inside registors to ensure none is destroyed (callee_saves)
    ST R0, djr0
    ST R1, djr1
    ST R2, djr2
    ST R3, djr3
    ST R4, djr4
    ST R5, djr5
    LD R5, rowcounterandheading
    LEA R0, spacebeginning
    TRAP x22
    LEA R0, topheaderline
    TRAP x22
    LD R1, displaygrid ;gets gridaddress from top
    LD R4, characterzero
    djrunitback
        AND R3, R5, x0001  ;mask to check if number is even or odd. 0 =even 1 = odd
        BRz evenrow
        LEA R0, spaceallign
        TRAP x22
        BR djskipto
        
    evenrow
    ADD R0, R4, #0
    TRAP x21
    ADD R4, R4, #1
   djskipto 
    LEA R0, spaceallign
    TRAP x22
    AND R0, R0, #0 ;clears previous stuff to prepare address of griddisplay
    ADD R0, R0, R1 ;gets address of griddisplay
    TRAP x22 ;display first line of grid 
    ADD R1, R1, #9   ; how to move on?  == 17 for a line, spots to go past to make a new line
    ADD R1, R1, #9  ;, so add R1 by 18
    LEA R0, spacebeginning ;moves pointer display to next following line
    TRAP x22
    ADD R5, R5, #-1
    BRnp djrunitback
    
    
    
    
    LD R0, djr0  ;load all previous contents ensure that nothing is destroyed or lost
    LD R1, djr1
    LD R2, djr2
    LD R3, djr3
    LD R4, djr4
    LD R5, djr5
    JMP R7
    
djr0 .BLKW #1
djr1 .BLKW #1
djr2 .BLKW #1
djr3 .BLKW #1
djr4 .BLKW #1
djr5 .BLKW #1

rowcounterandheading .FILL #17
characterzero .FILL x30
spaceallign .STRINGZ " "
displaygrid .FILL GRID       ;x302B location of grid
topheaderline .STRINGZ "   0 1 2 3 4 5 6 7 \n"    ;is the top part of the grid for headers
spacebeginning .STRINGZ "\n"  ;this creates a new line or a line of spaces 
;to note: \n creates a new line as said above^^^

;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
; Your Program 3 code goes here
ST R7, savejumpr7 ;saves R7 speceifically because an additonal subroutine is called
    ST R0, ljr0 ;save all previous contents inside registors to ensure none is destroyed (callee_saves)
    ST R1, ljr1
    ST R2, ljr2
    ST R3, ljr3
    ST R4, ljr4
    ST R5, ljr5
    ST R6, ljr6
    
    ; I = x49 , H = x48 , # = x23
    loadjunglerunitback LDR R3, R0, #0 ; linkedlist next head address
    LDR R1, R0, #1 ; linkedlist row number
    LDR R2, R0, #2 ; linkedlist column number
    LDR R4, R0, #3 ; linked list character gridblock type
    LD R5, minusconstant
    ADD R6, R4, R5 ;loads x-48 into R6 and x-48 + R3 would give three options
    BRn hyena
    ADD R6, R6, #-1 ;at this point, R6 is either zero, or one, 
                    ;to check if home or inital we subtract by one
    BRz inital ;imples that character is x49, so skip to inital, else implies is character home
    LD R6, gethomerow
    STR R1, R6, #0      ;updates the home coordinates that assignment wants
    LD R6, gethomecolumn
    STR R2, R6, #0
    BRnzp hyena
    
    inital
    ;LD R3, characterinital
    LD R4, characterinital
    LD R6, getcurrentrow
    STR R1, R6, #0         ;updates the current coordinates that assignment wants
    LD R6, getcurrentcolumn
    STR R2, R6, #0
    BRnzp hyena
    
    hyena
    JSR GRID_ADDRESS  ;calls function to find location of where to  whatever
    STR R4, R0, #0
    ADD R3, R3, #0  ;this line checks if the next head address is x0000 meaning end of linkedlist
    Brz endlinkedlist
    ADD R0, R3, #0  ;moves on to next gridblock, stored into R0
    BRnzp loadjunglerunitback
    
    
endlinkedlist    LD R7, savejumpr7
    LD R0, ljr0
    LD R1, ljr1
    LD R2, ljr2
    LD R3, ljr3
    LD R4, ljr4
    LD R5, ljr5
    LD R6, ljr6
    JMP  R7
savejumpr7 .BLKW #1
ljr0 .BLKW #1
ljr1 .BLKW #1
ljr2 .BLKW #1 
ljr3 .BLKW #1
ljr4 .BLKW #1
ljr5 .BLKW #1
ljr6 .BLKW #1
getcurrentrow .FILL CURRENT_ROW
getcurrentcolumn .FILL CURRENT_COL
gethomerow .FILL HOME_ROW
gethomecolumn .FILL HOME_COL
minusconstant .FILL x-48
characterinital .FILL x2A
characterhome .FILL x48
characterhyena .FILL x23

;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS     
; Your Program 3 code goes here
    ;input of R1 (row #) and R2 (column #)
    ;math function to be done == gridmemoryaddress + 18(2*r1+1) + (2*R2+1)
    
    ;save all previous contents inside registors to ensure none is destroyed (callee_saves)
    ST R1, gar1
    ST R2, gar2
    ST R3, gar3
    ST R4, gar4
    ST R5, gar5
    ST R6, gar6
    
    LD R6, getaddressgrid  ;gets base memory location
    AND R4, R4, #0   ;need to clear the registers before doing the math function
    AND R3, R3, #0  
    twotimesr1
    ADD R3, R3, #2      ;this multiplies R1 by 2 
    ADD R1, R1, #-1     ;by input number of R1
    Brzp twotimesr1     ; the ZP bits account for the GRID (0,0) input
    ADD R3, R3, #-1 ;   minus one to move row to down to correct location
    
    AND R5, R5, #0 ;clears new R5 for next math operation
    multiplyby18
    ADD R5, R5, #9    ;these two lines multiply the (2*r1+1)
    ADD R5, R5, #9      ;by 18 for every increment
    ADD R3, R3, #-1     ;this portion is stored ass (2*r1+1)
    BRnp multiplyby18 
    
    ;------------------ finished with the row finding, now onto column memory finding
    ;------------------ similar process with row as well.
    
    
    twotimesr2
    ADD R4, R4, #2     ;this multiplies R2 by 2
    ADD R2, R2, #-1     ;by input number of R2
    BRzp twotimesr2  ; the ZP bits account for the GRID (0,0) input
    ADD R4, R4, #-1   ;minus one to move column down to correct location as well.
    
    
    ;sums up the two memory locations calculated to get the actual memory location
    ADD R6, R6, R5
    ADD R6, R6, R4
    
    ;store into R0
    AND R0, R0, #0
    ADD R0, R0, R6
    
    
    
    LD R1, gar1 ;load all previous contents ensure that nothing is destroyed or lost
    LD R2, gar2 
    LD R3, gar3
    LD R4, gar4
    LD R5, gar5
    LD R6, gar6
    JMP R7
    
 gar1 .BLKW #1
 gar2 .BLKW #1
 gar3 .BLKW #1
 gar4 .BLKW #1
 gar5 .BLKW #1
 gar6 .BLKW #1
getaddressgrid .FILL GRID

;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output:  R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************

IS_INPUT_VALID
; Your New (Program4) code goes here
;going to make r1 = i,  r3 = j, r4 = k, r5 = l
 ST R0, IIVr0
 ST R1, IIVr1
 ST R3, IIVr3
 ST R4, IIVr4
 
;load characters into registers
LEA R1, chari
runitbackIVV 
LDR R3, R1, #0
BRz endofarraychecker ;if the input char doesnt match with r,j,k,l
ADD R4, R0, R3 ; checks if equal to zero
BRz valid
ADD R1, R1, #1
BRnzp runitbackIVV

endofarraychecker
LD R2, invalidnum
BR IVVend

valid
LD R2, validnum
BR IVVend

IVVend
 LD R0, IIVr0
 LD R1, IIVr1
 LD R3, IIVr3
 LD R4, IIVr4
    JMP R7

invalidnum .FILL #-1
validnum .FILL #0
IIVr0 .BLKW #1
IIVr1 .BLKW #1
IIVr3 .BLKW #1
IIVr4 .BLKW #1
IIVr5 .BLKW #1
chari .FILL x-69
charj .FILL x-6A
chark .FILL x-6B
charl .FILL x-6C
arrayend .FILL x0000
;***********************************************************
; SAFE_MOVE
; Input: R0 has 'i','j','k','l'
; Output: R1, R2 have the new row and col if the move is safe
;         If the move is unsafe, that is, the move would 
;         take Simba to a Hyena or outside the Grid then 
;         return R1=-1 
; Notes: Translates user entered move to actual row and column
;        Also checks the contents of the intended space to
;        move to in determining if the move is safe
;        Calls GRID_ADDRESS
;        This subroutine does not check if the input (R0) is 
;        valid. This functionality is implemented elsewhere.
;***********************************************************

SAFE_MOVE      
; Your New (Program4) code goes here
; you have your new current row and current col
; convert it to address
; check if address has hyena or OOB
; if hyena or OOB ->
; else return new location
ST R7, jumpr7_SM  ;calleee_saves
ST R0, SMr0
ST R4, SMr4
ST R5, SMr5
ST R6, SMr6

LDI R1, getcurrentrowSM
LDI R2, getcurrentcolumnSM

LD R3, chariSM
ADD R4, R0, R3
BRz updatebychari ;checks if does equal char i

LD R3, charjSM
ADD R4, R0, R3
BRz updatebycharj 

LD R3, charkSM
ADD R4, R0, R3
BRz updatebychark 

LD R3, charlSM
ADD R4, R0, R3
BRz updatebycharl

updatebychari
ADD R1, R1, #-1 ; moving up 1, subtracting 1 from row
BR checkheyna_outvertical

updatebycharj
ADD R2, R2, #-1 ; moving left 1
BR checkheyna_outhorizontal

updatebychark
ADD R1, R1, #1 ; moving down 1
BR checkheyna_outvertical

updatebycharl
ADD R2, R2, #1; moving right 1
BR checkheyna_outhorizontal

checkheyna_outvertical
;check for out of bounds for bottom row
AND R5, R5, #0 ; clear register
ADD R5, R5, #-8 ; set R5 to -8
ADD R5, R5, R1 ; checks if current row is out of bounds on bottom
BRzp SMoutofbound ; if yes, it's out of bounds
;check out of bounds for top row
AND R5, R5, #0
ADD R5, R5, #1
ADD R5, R5, R1
BRnz SMoutofbound
BR SMnotoutofbound
checkheyna_outhorizontal
;check out of bounds for bottom column
AND R5, R5, #0
ADD R5, R5, #-8
ADD R5, R5, R2
BRzp SMoutofbound
;check out of bounds for top column
AND R5, R5, #0
ADD R5, R5, #1
ADD R5, R5, R2
BRnz SMoutofbound
BR SMnotoutofbound

SMnotoutofbound
JSR GRID_ADDRESS
LDR R5, R0, #0 ;grabs the symbol (could be heyna/outofbounds/space)
;; check whether heyna is here
LD R6, characterhyenaSM
ADD R6, R5, R6
BRnp end_SM

;if doesnt branch, then there is hyena
AND R1, R1, #0
ADD R1, R1, #-1
BR end_SM

SMoutofbound
AND R1, R1, #0
ADD R1, R1, #-1
BR end_SM



end_SM
LD R7, jumpr7_SM
LD R0, SMr0
LD R4, SMr4
LD R5, SMr5
LD R6, SMr6
    JMP R7
    
jumpr7_SM .BLKW #1
SMr0 .BLKW #1
SMr3 .BLKW #1
SMr4 .BLKW #1
SMr5 .BLKW #1
SMr6 .BLKW #1
chariSM .FILL x-69
charjSM .FILL x-6A
charkSM .FILL x-6B
charlSM .FILL x-6C
getcurrentrowSM .FILL CURRENT_ROW
getcurrentcolumnSM .FILL CURRENT_COL
gethomerowSM .FILL HOME_ROW
gethomecolumnSM .FILL HOME_COL
characterhyenaSM .FILL x-23
;***********************************************************
; APPLY_MOVE
; This subroutine makes the move if it can be completed. 
; It checks to see if the movement is safe by calling 
; SAFE_MOVE which returns the coordinates of where the move 
; goes (or -1 if movement is unsafe as detailed below). 
; If the move is Safe then this routine moves the player 
; symbol to the new coordinates and clears any walls (|�s and -�s) 
; as necessary for the movement to take place. 
; If the movement is unsafe, output a console message of your 
; choice and return. 
; Input:  
;         R0 has move (i or j or k or l)
; Output: None; However must update the GRID and 
;               change CURRENT_ROW and CURRENT_COL 
;               if move can be successfully applied.
; Notes:  Calls SAFE_MOVE and GRID_ADDRESS
;***********************************************************

APPLY_MOVE   
; Your New (Program4) code goes here
; call safe_move
; if not safe then safe_move will return -1 so if you get -1 then display console message and simba's row/col stays the same
; go to place where user can input more
; if safe, then safe_move will return the correct row/col
; move the simba there

; also delete the line at the location of new location (depends which direction)

ST R7, jumpr7AM
ST R0, AMr0
ST R1, AMr1
ST R2, AMr2
ST R3, AMr3
ST R4, AMr4
ST R5, AMr5
ST R6, AMr6

LDI R5, getcurrentrowAM
LDI R6, getcurrentcolumnAM  ; get the current location of simba

JSR SAFE_MOVE   ; based on r0 returns if invalid, returns -1, else valid and reutrns r1 and r2 with updated move rol/col
ADD R1, R1, #0 ; want to Br based on R1
BRn notsafeAM   ;not safe branch - don't clear locatino of simba and also don't update the new locatin of simba

JSR GRID_ADDRESS  ;input is R1,R2 and output is R0 ;returns the new updated address that you want to put simba in it in r0
LD R3, charactersimbaAM
STR R3, R0, #0 ; puts simba in new location in diagram

LD R4, getcurrentrowAM
STR R1, R4, #0
LD R4, getcurrentcolumnAM
STR R2, R4, #0   ;;all of this updates SIMBA to new location in database

ADD R1, R5, #0
ADD R2, R6, #0
JSR GRID_ADDRESS ; input is R1,R2 and output is R0
LD R3, characterblankAM ; you CANNOT clear the location of simba UNTIL you are sure that it is a safe_move. otherwise simba stays in the same place you can't delete him. so this needs to come after safe_move
STR R3, R0, #0
;--------------------------------------------------------------- next lines of code delete the pipe or dash boundaries to show simbas path

LD R5, AMr0 ;loads up the input character again but this time into a dummy register R5, keep in mind that R0 still has the memory address from grid_address

LD R3, chariAM
ADD R4, R5, R3
BRz updatebychari_AM ;checks if does equal char i

LD R3, charjAM
ADD R4, R5, R3
BRz updatebycharj_AM 

LD R3, charkAM
ADD R4, R5, R3
BRz updatebychark_AM 

LD R3, charlAM
ADD R4, R5, R3
BRz updatebycharl_AM
;-------------------------------------------
updatebychari_AM
ADD R0, R0, #-9 ;now you are at the memory address on top of it
ADD R0, R0, #-9
LD R3, characterblankAM 
STR R3, R0, #0
BR endAM

updatebycharj_AM
ADD R0, R0, #-1 ;now you are at the memory address to the left of it
LD R3, characterblankAM 
STR R3, R0, #0
BR endAM

updatebychark_AM
ADD R0, R0, #9 ;now you are at the memory address below it
ADD R0, R0, #9
LD R3, characterblankAM 
STR R3, R0, #0
BR endAM

updatebycharl_AM
ADD R0, R0, #1 ;now you are at the memory address to the right of it
LD R3, characterblankAM 
STR R3, R0, #0
BR endAM


BR endAM

notsafeAM
LEA   R0, NOTSAFE_STRING
        TRAP  x22                        ; outputs notsafe console message
endAM
LD R7, jumpr7AM
LD R0, AMr0
LD R1, AMr1
LD R2, AMr2
LD R3, AMr3
LD R4, AMr4
LD R5, AMr5
LD R6, AMr6
    JMP R7
chariAM .FILL x-69
charjAM .FILL x-6A
charkAM .FILL x-6B
charlAM .FILL x-6C
characterblankAM .FILL x20
charactersimbaAM .FILL x2A
getcurrentrowAM .FILL CURRENT_ROW
getcurrentcolumnAM .FILL CURRENT_COL
jumpr7AM .BLKW #1
AMr0 .BLKW #1
AMr1 .BLKW #1
AMr2 .BLKW #1
AMr3 .BLKW #1
AMr4 .BLKW #1
AMr5 .BLKW #1
AMr6 .BLKW #1
    
    
NOTSAFE_STRING      .STRINGZ "\n!You can't go that way!\n"    
;***********************************************************
; IS_SIMBA_HOME
; Checks to see if the Simba has reached Home.
; Input:  None
; Output: R2 is zero if Simba is Home; -1 otherwise
; 
;***********************************************************

IS_SIMBA_HOME     
    ; Your code goes here
    ST R0, SHr0
    ST R1, SHr1
    ST R3, SHr3
    ST R4, SHr4
    ST R5, SHr5
    
    LDI R0, getcurrentrowSH
    LDI R1, getcurrentcolumnSH        ;loads all the current/home row/col coordinates
    LDI R3, gethomerowSH
    LDI R4, gethomecolumnSH
    
    NOT R3, R3
    ADD R3, R3, #1  
    NOT R4, R4              ;makes the home rol/col negative number coords in order to compare
    ADD R4, R4, #1
    
    ADD R5, R0, R3   ;checks if current row is home row
    BRz rowcurrentishome   ;moves to then check the columns
    BR nothomeSH
    
    rowcurrentishome
    ADD R5, R1, R4       ;checks if current coliumn is home column
    BRz columncurrentishome
    BR nothomeSH
    
    columncurrentishome
    AND R2, R2, #0 ;sets output --- R2 is now zero
    BR endSH
    
    nothomeSH
    AND R2, R2, #0    ;sets output --- R2 is -1 bc simba is not home
    ADD R2, R2, #-1
    BR endSH
    
    endSH
    LD R0, SHr0
    LD R1, SHr1
    LD R3, SHr3
    LD R4, SHr4
    LD R5, SHr5
    JMP R7
SHr0 .BLKW #1
SHr1 .BLKW #1
SHr3 .BLKW #1
SHr4 .BLKW #1
SHr5 .BLKW #1
getcurrentrowSH .FILL CURRENT_ROW
getcurrentcolumnSH .FILL CURRENT_COL
gethomerowSH .FILL HOME_ROW
gethomecolumnSH .FILL HOME_COL    
    .END

; This section has the linked list for the
; Jungle's layout: #(0,1)->H(4,7)->I(2,1)->#(1,1)->#(6,3)->#(3,5)->#(4,4)->#(5,6)
	.ORIG	x5000
	.FILL	Head   ; Holds the address of the first record in the linked-list (Head)
blk2
	.FILL   blk4
	.FILL   #1
    .FILL   #1
	.FILL   x23

Head
	.FILL	blk1
    .FILL   #0
	.FILL   #1
	.FILL   x23

blk1
	.FILL   blk3
	.FILL   #4
	.FILL   #7
	.FILL   x48

blk3
	.FILL   blk2
	.FILL   #2
	.FILL   #1
	.FILL   x49

blk4
	.FILL   blk5
	.FILL   #6
	.FILL   #3
	.FILL   x23

blk7
	.FILL   #0
	.FILL   #5
	.FILL   #6
	.FILL   x23
blk6
	.FILL   blk7
	.FILL   #4
	.FILL   #4
	.FILL   x23
blk5
	.FILL   blk6
	.FILL   #3
	.FILL   #5
	.FILL   x23
	.END
