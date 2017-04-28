INCLUDE Irvine32.inc

;--------------------------------------------------------
;Student:Michael Tretiak
;CPSC 355 Assignment 4
; Program is to behavor like an ATM
; First prompt for account and pin
; then let user decide which option to pick from 5 choices
; NOTE: THIS PROGRAM IS NOT FINISHED. PROGRAM WILL RUN IF YOU DO NOT ENTER A PIN
;PROGRAM WILL NOT CHECK PIN. 
;-------------------------------------------------------

;-------------------
;Data
;-------------------
.Data

	;array for account numbers
	accountNumbers DWORD 10021331, 1232244, 44499922, 10222334
	;array for pins
	pins WORD 2341, 3345, 1923, 3456
	; array for balances
	balances DWORD 1000, 0, 80000, 4521
	;count for which account
	countCheck BYTE 4

	;msgs
	msgAccountNum BYTE "Please enter account number: ",0
	msgPin BYTE "Please enter your pin: ",0
	msgDisplayBalance BYTE "1) Display Balance",0
	msgWithdraw BYTE "2) Withdraw",0
	msgDeposit BYTE "3) Deposit",0
	msgPrint BYTE "4) Print Receipt",0
	msgExit BYTE "5) Exit",0

	msgAccountNumber BYTE "Account Number: ",0

	msgWithdrawAmount BYTE "How much would you like to withdraw?",0

	msgHere BYTE "here",0

	msgDepositType BYTE "Enter 1 for Cheque 2 for Cash",0
	msgDepositCash BYTE "In increments of $10 how much would you like to deposit?",0
	msgDepositCheque BYTE "How much would you like to deposit?",0
	msgErrorAccount BYTE "No account found.",0

	msgWithdrawHigh BYTE "Withdraw is too high, not enough cash in account or over $1000",0
	msgDone BYTE "Thanks you, goodbye.",0
	msgWithdrawSuccesful BYTE "Withdraw Successful! New balance: ",0
	msgDepositSuccessful BYTE "Deposit Successful! New balance: ",0
	msgWithdrawTotal BYTE "Withdraw Total: ",0
	msgDepositTotal BYTE "Deposit Total: ",0

	;values
	accountNumber DWORD ?
	pin WORD ?
	withdrawAmount WORD ?
	depositAmount WORD ?
	totalWithdraw WORD 0
	totalDeposit WORD ?




;--------------
;CODE
;--------------
.CODE

;-------------------------------------------------------
;MAIN
;-------------------------------------------------------

	main PROC
		call info
		;call displayBalance
		;call withdraw
		call prompt

		;call deposit

		;call done



	;exit;promts for exit
	main ENDP;ends main

;-------------------------------------------------------
;Account Info
;find out how to make this a proc
;-------------------------------------------------------
	info Proc
	pushad

		;-------------------------------------------------------
		;prompts for account number
		;still need to write check against account array
		;still need to write error and compare to ecx
		;-------------------------------------------------------
			mov ecx, 0 ;set to zero for our count
			account:
				mov edx, OFFSET msgAccountNum
				call WriteString

				call ReadInt
				mov accountNumber, eax

				call Crlf
				;mov eax,accountNumber

				mov eax, accountNumber
				;call WriteInt
				mov ecx, 4
				mov edx,0

				;count BYTE 3

				L1:
					mov edx, accountNumbers[ecx*4]
					cmp eax, edx
					;jump when equal and print balance
					je N1
				loop L1

				cmp eax, edx
				jne N2

				N2:
					mov edx, OFFSET msgErrorAccount
					call writestring
					call info




				;mov edx, accountNumber;for error checking
				;call WriteInt
				N1:
				mov edx, OFFSET msgPin
				call WriteString

				call ReadInt
				mov pin, ax






				;mov dx, pin;error checking
				;call writeInt

				call Crlf
		popad
		ret
		info ENDP
		;-------------------------------------------------------
		;msg prompt
		;-------------------------------------------------------
		prompt Proc
			mov edx, OFFSET msgDisplayBalance
			call WriteString
			call Crlf

			mov edx, OFFSET msgWithdraw
			call WriteString
			call Crlf

			mov edx, OFFSET msgDeposit
			call WriteString
			call Crlf

			mov edx, OFFSET msgPrint
			call WriteString
			call crlf

			mov edx, OFFSET msgExit
			call WriteString
			call Crlf

			call ReadInt
			mov dx, ax

			cmp ax,1
				je displayBalance1



			cmp ax,2
				je withdraw1

			cmp ax,3
				je deposit1

			cmp ax, 4
				je print1

			cmp ax,5
				je done1



			displayBalance1:
				call displayBalance

			withdraw1:
				call withdraw

			deposit1:
				call deposit

			print1:
				call print

			done1:
				call done


			;call WriteInt
			;call Crlf

			;checks if input was correct, if not jumps back up to prompt user again
			cmp ax, 5
			ja prompt
		ret
		prompt ENDP

		;-------------------------------------------------------
		;Display Balance
		;-------------------------------------------------------
			displayBalance Proc
				mov eax, accountNumber
				;call WriteInt
				mov ecx, 4
				mov edx,0

				;count BYTE 3

				L1:
					mov edx, accountNumbers[ecx*4]
					cmp eax, edx
					;jump when equal and print balance
					je N1
				loop L1

				N1:

					mov eax, balances[ecx*4]
					call WriteInt
					call Crlf



			mov eax,0
			mov edx,0
			call prompt

			ret
			displayBalance ENDP
		;-------------------------------------------------------
		;Withdraw
		;-------------------------------------------------------
			withdraw Proc

				mov edx, OFFSET msgWithdrawAmount
				Call WriteString
				call crlf
				call ReadInt
				mov withdrawAmount, ax

				mov bx, 1000

				;1000>withdrawAmount?
				cmp  withdrawAmount, bx ;compares to see if withdraw is larger than 1000
				ja errorHigh

				;call WriteInt

				;finds account number and holds counter
				mov eax, accountNumber
				mov ecx, 4

				L2:
					mov edx, accountNumbers[ecx*4]
					cmp eax, edx
					;jump when equal and print balance
					je N2
				loop L2


				N2:
					mov eax, balances[ecx*4]
					;ax>withdrawAmount?
					cmp ax, withdrawAmount ; compares to see if there is enough cash
					jb errorHigh
					ja subJump
					;enter jump

						subJump:
							;mov edx, OFFSET msgHere
							;call WriteString

							sub ax, withdrawAmount
							mov balances[ecx*4], eax

							;mov ax,withdrawAmount
							;add totalWithdraw, ax

							;call WriteInt
							;call Crlf
							;mov dx,0
							;mov ax,0
							;cmp ax,dx
							jmp next

						errorHigh:

							mov edx,OFFSET msgWithdrawHigh ;change to error message
							call WriteString
							call crlf
							call withdraw



						next:;jump here if we did sub
						;call display balance




			mov edx, OFFSET msgWithdrawSuccesful
			call writestring
			call writeInt
			call Crlf

			mov ax,totalWithdraw
			add ax, withdrawAmount
			mov totalWithdraw,ax
			;call WriteInt

			mov ax,0
			call prompt
			ret
			withdraw ENDP


		 ;-------------------------------------------------------
		 ;Deposit
		  ;-------------------------------------------------------
deposit Proc

	mov edx, OFFSET msgDepositType
	call WriteString
	call Crlf

	call ReadInt
	;call writeInt
	call crlf

	cmp ax,1
	je cheque



	cmp ax,2
	je cash


	cash:
		mov edx,OFFSET msgDepositCash
		call WriteString
		call crlf
		call ReadInt
		;call crlf
		mov depositAmount, ax


		jmp next

		;jumps to l2 when done
		;mov edx, OFFSET msgHERE
		;call writeString
		cheque:
		mov edx, OFFSET msgDepositCheque
		call WriteString
		call crlf
		call ReadInt
		call Crlf
		mov depositAmount, ax
		next:

	mov eax,0
	mov edx,0
	mov eax, accountNumber
	mov ecx, 4


	L2:
		mov edx, accountNumbers[ecx*4]
		cmp eax, edx
		;jump when equal and print balance
		je N2
	loop L2

	N2:
		mov eax, balances[ecx*4]
		add ax, depositAmount
		mov balances[ecx*4], eax


	mov edx, OFFSET msgDepositSuccessful
	call writestring
	call writeint
	call Crlf
	mov ax,0
	call prompt


ret
deposit ENDP


print Proc

	call Crlf
	mov edx, OFFSET msgAccountNumber
	call WriteString
	call Crlf
	mov eax, accountNumber
	call WriteInt
	call crlf


	mov eax,0
	call Crlf
	mov edx, OFFSET msgWithdrawTotal
	call writestring
	call crlf
	mov ax, totalWithdraw
	call WriteInt
	call crlf


	call prompt
ret
print ENDP


done Proc
	mov edx, OFFSET msgDone
	call WriteString
	call Crlf

	exit
done ENDP



END main;ends all
