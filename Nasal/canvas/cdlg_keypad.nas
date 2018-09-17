var cdlg_keyboard = {

	update_flag:  0,

	init: func {


		var width = 330;
		var height = 512;
		var img_path = "Aircraft/SpaceShuttle/Dialogs/keypad.png";
						



		var window = canvas.Window.new([width,height],"dialog").set("title", "Keyboard Unit");

		# we need to explicitly re-define this to get a handle to stop the update loop
		# upon closing the window

		window.del = func()
		{
		  #print("Cleaning up...\n");
		  SpaceShuttle.cdlg_keyboard.update_flag = 0;
		  call(canvas.Window.del, [], me);
		};


		var tempCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));
		me.root = tempCanvas.createGroup();
		var child=me.root.createChild("image")
				                   .setFile(img_path )
				                   .setTranslation(0,0)
				                   .setSize(width,height);


		var stack = [];
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_fault_sum.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_fault_sum_pressed.png");

		me.key_fault_summ = cdlg_widget_img_stack.new(me.root, stack, 48, 49, 1);
		me.key_fault_summ.setTranslation(63,49);
		me.key_fault_summ.f = func { SpaceShuttle.key_fault_summ(1);};

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_sys_sum.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_sys_sum_pressed.png");

		me.key_sys_summ = cdlg_widget_img_stack.new(me.root, stack, 48, 49, 1);
		me.key_sys_summ.setTranslation(116,49);
		me.key_sys_summ.f = func {SpaceShuttle.key_sys_summ(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_msg_reset.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_msg_reset_pressed.png");

		me.key_msg_reset = cdlg_widget_img_stack.new(me.root, stack, 47, 48, 1);
		me.key_msg_reset.setTranslation(169,49);
		me.key_msg_reset.f = func {SpaceShuttle.key_msg_reset(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_ack.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_ack_pressed.png");

		me.key_ack = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_ack.setTranslation(222,49);
		me.key_ack.f = func {SpaceShuttle.key_ack(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_gpc_crt.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_gpc_crt_pressed.png");

		me.key_gpc_crt = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_gpc_crt.setTranslation(63,102);
		me.key_gpc_crt.f = func {SpaceShuttle.key_gpc_crt(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_A.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_A_pressed.png");

		me.key_A = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_A.setTranslation(116,102);
		me.key_A.f = func {SpaceShuttle.key_symbol(1, "A");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_B.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_B_pressed.png");

		me.key_B = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_B.setTranslation(169,102);
		me.key_B.f = func {SpaceShuttle.key_symbol(1, "B");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_C.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_C_pressed.png");

		me.key_C = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_C.setTranslation(222,101);
		me.key_C.f = func {SpaceShuttle.key_symbol(1, "C");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_io_reset.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_io_reset_pressed.png");

		me.key_io_reset = cdlg_widget_img_stack.new(me.root, stack, 47, 47, 1);
		me.key_io_reset.setTranslation(64,155);
		me.key_io_reset.f = func {SpaceShuttle.key_io_reset(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_D.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_D_pressed.png");

		me.key_D = cdlg_widget_img_stack.new(me.root, stack, 47, 48, 1);
		me.key_D.setTranslation(117,154);
		me.key_D.f = func {SpaceShuttle.key_symbol(1, "D");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_E.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_E_pressed.png");

		me.key_E = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_E.setTranslation(169,154);
		me.key_E.f = func {SpaceShuttle.key_symbol(1, "E");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_F.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_F_pressed.png");

		me.key_F = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_F.setTranslation(222,154);
		me.key_F.f = func {SpaceShuttle.key_symbol(1, "F");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_item.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_item_pressed.png");

		me.key_item = cdlg_widget_img_stack.new(me.root, stack, 47, 47, 1);
		me.key_item.setTranslation(64,207);
		me.key_item.f = func {SpaceShuttle.key_item(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_1.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_1_pressed.png");

		me.key_1 = cdlg_widget_img_stack.new(me.root, stack, 47, 47, 1);
		me.key_1.setTranslation(117,207);
		me.key_1.f = func {SpaceShuttle.key_symbol(1, "1");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_2.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_2_pressed.png");

		me.key_2 = cdlg_widget_img_stack.new(me.root, stack, 47, 47, 1);
		me.key_2.setTranslation(170,207);
		me.key_2.f = func {SpaceShuttle.key_symbol(1, "2");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_3.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_3_pressed.png");

		me.key_3 = cdlg_widget_img_stack.new(me.root, stack, 47, 47, 1);
		me.key_3.setTranslation(222,207);
		me.key_3.f = func {SpaceShuttle.key_symbol(1, "3");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_exec.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_exec_pressed.png");

		me.key_exec = cdlg_widget_img_stack.new(me.root, stack, 46, 46, 1);
		me.key_exec.setTranslation(65,260);
		me.key_exec.f = func {SpaceShuttle.key_exec(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_4.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_4_pressed.png");

		me.key_4 = cdlg_widget_img_stack.new(me.root, stack, 47, 47, 1);
		me.key_4.setTranslation(117,259);
		me.key_4.f = func {SpaceShuttle.key_symbol(1, "4");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_5.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_5_pressed.png");

		me.key_5 = cdlg_widget_img_stack.new(me.root, stack, 46, 47, 1);
		me.key_5.setTranslation(170,259);
		me.key_5.f = func {SpaceShuttle.key_symbol(1, "5");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_6.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_6_pressed.png");

		me.key_6 = cdlg_widget_img_stack.new(me.root, stack, 47, 46, 1);
		me.key_6.setTranslation(222,259);
		me.key_6.f = func {SpaceShuttle.key_symbol(1, "6");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_ops.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_ops_pressed.png");

		me.key_ops = cdlg_widget_img_stack.new(me.root, stack, 47, 46, 1);
		me.key_ops.setTranslation(65,312);
		me.key_ops.f = func {SpaceShuttle.key_ops(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_7.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_7_pressed.png");

		me.key_7 = cdlg_widget_img_stack.new(me.root, stack, 48, 47, 1);
		me.key_7.setTranslation(117,311);
		me.key_7.f = func {SpaceShuttle.key_symbol(1, "7");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_8.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_8_pressed.png");

		me.key_8 = cdlg_widget_img_stack.new(me.root, stack, 47, 47, 1);
		me.key_8.setTranslation(170,311);
		me.key_8.f = func {SpaceShuttle.key_symbol(1, "8");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_9.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_9_pressed.png");

		me.key_9 = cdlg_widget_img_stack.new(me.root, stack, 47, 47, 1);
		me.key_9.setTranslation(222,311);
		me.key_9.f = func {SpaceShuttle.key_symbol(1, "9");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_spec.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_spec_pressed.png");

		me.key_spec = cdlg_widget_img_stack.new(me.root, stack, 47, 48, 1);
		me.key_spec.setTranslation(65,363);
		me.key_spec.f = func {SpaceShuttle.key_spec(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_minus.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_minus_pressed.png");

		me.key_minus = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_minus.setTranslation(117,363);
		me.key_minus.f = func {SpaceShuttle.key_delimiter(1, "-");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_0.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_0_pressed.png");

		me.key_0 = cdlg_widget_img_stack.new(me.root, stack, 48, 47, 1);
		me.key_0.setTranslation(170,363);
		me.key_0.f = func {SpaceShuttle.key_symbol(1, "0");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_plus.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_plus_pressed.png");

		me.key_plus = cdlg_widget_img_stack.new(me.root, stack, 48, 47, 1);
		me.key_plus.setTranslation(222,363);
		me.key_plus.f = func {SpaceShuttle.key_delimiter(1, "+");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_resume.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_resume_pressed.png");

		me.key_resume = cdlg_widget_img_stack.new(me.root, stack, 47, 48, 1);
		me.key_resume.setTranslation(65,415);
		me.key_resume.f = func {SpaceShuttle.key_resume(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_clear.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_clear_pressed.png");

		me.key_clear = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_clear.setTranslation(117,415);
		me.key_clear.f = func {SpaceShuttle.key_clear(1);}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_decimal.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_decimal_pressed.png");

		me.key_decimal = cdlg_widget_img_stack.new(me.root, stack, 48, 48, 1);
		me.key_decimal.setTranslation(170,415);
		me.key_decimal.f = func {SpaceShuttle.key_symbol(1, ".");}

		setsize(stack,0);
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_pro.png");
		append(stack, "Aircraft/SpaceShuttle/Dialogs/keypad_pro_pressed.png");

		me.key_pro = cdlg_widget_img_stack.new(me.root, stack, 48, 49, 1);
		me.key_pro.setTranslation(222,414);
		me.key_pro.f = func {SpaceShuttle.key_pro(1);}

		},
};
