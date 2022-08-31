.686
.model	flat, stdcall
option	casemap :none

include bones.inc
include BoxProc.asm

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	InitCommonControls
	invoke	DialogBoxParam, hInstance, IDD_MAIN, 0, offset DlgProc, 0
	invoke	ExitProcess, eax

DlgProc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
LOCAL ps:PAINTSTRUCT
	mov	eax,uMsg
	
	.if	eax == WM_INITDIALOG
		invoke	LoadIcon,hInstance,200
		invoke	SendMessage, hWin, WM_SETICON, 1, eax
		invoke SetWindowText,hWin,addr WindowTitle
		invoke LoadBitmap,hInstance,300
		mov hIMG,eax
		invoke CreatePatternBrush,hIMG
		mov hBrush,eax
		invoke SkrBoxInit,hWin
	.elseif eax == WM_CTLCOLORDLG
		return hBrush
	.elseif eax == WM_PAINT
		invoke BeginPaint,hWin,addr ps
		mov edi,eax
		lea ebx,r3kt
		assume ebx:ptr RECT
	
		invoke GetClientRect,hWin,ebx
		invoke CreateSolidBrush,White
		invoke FrameRect,edi,ebx,eax
		invoke EndPaint,hWin,addr ps
	.elseif eax == WM_LBUTTONDOWN
		invoke SendMessage,hWin,WM_NCLBUTTONDOWN,HTCAPTION,0
	.elseif eax == WM_RBUTTONUP
		invoke SendMessage,hWin,WM_CLOSE,0,0
	.elseif eax == WM_CLOSE
		call CleanEf
		invoke EndDialog, hWin, 0
	.endif

	xor	eax,eax
	ret
DlgProc endp

end start