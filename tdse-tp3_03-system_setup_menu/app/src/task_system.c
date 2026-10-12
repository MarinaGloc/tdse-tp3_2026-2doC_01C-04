/*
 * Copyright (c) 2026 Juan Manuel Cruz <jcruz@fi.uba.ar>.
 * All rights reserved.
 */

#include "main.h"

#include "logger.h"
#include "dwt.h"

#include "board.h"
#include "app.h"
#include "task_actuator_attribute.h"
#include "task_actuator_interface.h"
#include "task_display_attribute.h"
#include "task_display_interface.h"
#include "task_system_attribute.h"
#include "task_system_interface.h"

#define DEL_SYS_MIN 0ul

typedef enum task_system_mode {NORMAL, SETUP, MODE_QTY} task_system_mode_t;

#define SYSTEM_DTA_QTY MODE_QTY

task_system_dta_t task_system_dta_list[SYSTEM_DTA_QTY];
system_setup_menu_dta_t system_setup_menu_dta;

static void task_system_normal_statechart(task_system_ev_t event);
static void task_system_setup_statechart(task_system_ev_t event);
static void task_system_set_mode(task_system_mode_t mode);
static void system_setup_reset_draft(void);
static void system_setup_save(void);
static void system_setup_handle_event(task_system_ev_t event);
static void system_setup_refresh_display(void);
static void system_display_lines(const char *line_1, const char *line_2);
static void system_pad_line(char output[17], const char *text);

const char *p_task_system = "Task System (System Setup Menu Statechart)";
const char *p_task_system_ = "Non-Blocking Code";
const char *p_task_system__ = "(Update by Time Code, period = 1mS)";

task_system_mode_t g_task_system_mode;

void task_system_init(void *parameters)
{
	uint32_t index;

	LOGGER_INFO(" ");
	LOGGER_INFO("  %s is running - Tick [mS] = %lu", GET_NAME(task_system_init), HAL_GetTick());
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system);
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system_);
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system__);

	init_event_task_system();

	for (index = 0; index < SYSTEM_DTA_QTY; index++)
	{
		task_system_dta_list[index].tick = DEL_SYS_MIN;
		task_system_dta_list[index].state = ST_SYS_IDLE;
		task_system_dta_list[index].event = EV_SYS_IDLE;
		task_system_dta_list[index].flag = false;
	}

	for (index = 0; index < SYSTEM_MOTOR_QTY; index++)
	{
		system_setup_menu_dta.saved[index].power = true;
		system_setup_menu_dta.saved[index].speed = 0u;
		system_setup_menu_dta.saved[index].spin = SYSTEM_SPIN_LEFT;
	}

	system_setup_menu_dta.level = MENU_LEVEL_MAIN;
	system_setup_menu_dta.motor = SYSTEM_MOTOR_1;
	system_setup_menu_dta.parameter = SYSTEM_PARAMETER_POWER;
	system_setup_reset_draft();

	task_system_set_mode(NORMAL);
	system_display_lines("task_system_mode", " NORMAL");
}

void task_system_update(void *parameters)
{
	task_system_ev_t event;

	if (!any_event_task_system())
	{
		return;
	}

	event = get_event_task_system();

	/* A release event also turns off the activity LED. */
	if (EV_SYS_IDLE == event)
	{
		put_event_task_actuator(EV_LED_IDLE, ID_LED_A);
	}

	switch (g_task_system_mode)
	{
		case NORMAL:
			task_system_normal_statechart(event);
			break;

		case SETUP:
			task_system_setup_statechart(event);
			break;

		default:
			task_system_set_mode(NORMAL);
			system_display_lines("task_system_mode", " NORMAL");
			break;
	}
}

static void task_system_normal_statechart(task_system_ev_t event)
{
	if (EV_SYS_BTN_A == event)
	{
		put_event_task_actuator(EV_LED_ACTIVE, ID_LED_A);
		system_setup_reset_draft();
		system_setup_menu_dta.level = MENU_LEVEL_MAIN;
		task_system_set_mode(SETUP);
		system_setup_refresh_display();
	}
}

static void task_system_setup_statechart(task_system_ev_t event)
{
	if (EV_SYS_BTN_A == event)
	{
		put_event_task_actuator(EV_LED_ACTIVE, ID_LED_A);
		task_system_set_mode(NORMAL);
		system_display_lines("task_system_mode", " NORMAL");
		return;
	}

	if ((EV_SYS_ENTER == event) || (EV_SYS_NEXT == event) ||
		(EV_SYS_ESCAPE == event))
	{
		system_setup_handle_event(event);
	}
}

static void system_setup_handle_event(task_system_ev_t event)
{
	system_motor_config_t *draft;

	draft = &system_setup_menu_dta.draft[system_setup_menu_dta.motor];

	switch (system_setup_menu_dta.level)
	{
		case MENU_LEVEL_MAIN:
			if (EV_SYS_ENTER == event)
			{
				system_setup_menu_dta.level = MENU_LEVEL_MOTOR;
			}
			else if (EV_SYS_ESCAPE == event)
			{
				task_system_set_mode(NORMAL);
				system_display_lines("task_system_mode", " NORMAL");
				return;
			}
			break;

		case MENU_LEVEL_MOTOR:
			if (EV_SYS_ENTER == event)
			{
				system_setup_menu_dta.level = MENU_LEVEL_PARAMETER;
			}
			else if (EV_SYS_NEXT == event)
			{
				system_setup_menu_dta.motor =
					(system_setup_menu_dta.motor == SYSTEM_MOTOR_1) ?
					SYSTEM_MOTOR_2 : SYSTEM_MOTOR_1;
			}
			else if (EV_SYS_ESCAPE == event)
			{
				system_setup_menu_dta.level = MENU_LEVEL_MAIN;
			}
			break;

		case MENU_LEVEL_PARAMETER:
			if (EV_SYS_ENTER == event)
			{
				system_setup_menu_dta.level = MENU_LEVEL_VALUE;
			}
			else if (EV_SYS_NEXT == event)
			{
				system_setup_menu_dta.parameter =
					(system_parameter_t)((system_setup_menu_dta.parameter + 1u) %
					SYSTEM_PARAMETER_QTY);
			}
			else if (EV_SYS_ESCAPE == event)
			{
				system_setup_menu_dta.level = MENU_LEVEL_MOTOR;
			}
			break;

		case MENU_LEVEL_VALUE:
			if (EV_SYS_NEXT == event)
			{
				switch (system_setup_menu_dta.parameter)
				{
					case SYSTEM_PARAMETER_POWER:
						draft->power = !draft->power;
						break;

					case SYSTEM_PARAMETER_SPEED:
						draft->speed = (uint8_t)((draft->speed + 1u) % 10u);
						break;

					case SYSTEM_PARAMETER_SPIN:
						draft->spin = (draft->spin == SYSTEM_SPIN_LEFT) ?
							SYSTEM_SPIN_RIGHT : SYSTEM_SPIN_LEFT;
						break;

					default:
						break;
				}
			}
			else if (EV_SYS_ESCAPE == event)
			{
				system_setup_menu_dta.level = MENU_LEVEL_PARAMETER;
			}
			else if (EV_SYS_ENTER == event)
			{
				system_setup_save();
				system_setup_menu_dta.level = MENU_LEVEL_MAIN;
			}
			break;

		default:
			system_setup_menu_dta.level = MENU_LEVEL_MAIN;
			break;
	}

	system_setup_refresh_display();
}

static void system_setup_reset_draft(void)
{
	uint32_t index;

	for (index = 0; index < SYSTEM_MOTOR_QTY; index++)
	{
		system_setup_menu_dta.draft[index] = system_setup_menu_dta.saved[index];
	}
}

static void system_setup_save(void)
{
	uint32_t index;

	for (index = 0; index < SYSTEM_MOTOR_QTY; index++)
	{
		system_setup_menu_dta.saved[index] = system_setup_menu_dta.draft[index];
	}
}

static void system_setup_refresh_display(void)
{
	char line_1[17];
	char line_2[17];
	char text[17];
	const system_motor_config_t *draft;

	draft = &system_setup_menu_dta.draft[system_setup_menu_dta.motor];

	switch (system_setup_menu_dta.level)
	{
		case MENU_LEVEL_MAIN:
			system_display_lines("SYSTEM SETUP", "Enter: configure");
			break;

		case MENU_LEVEL_MOTOR:
			snprintf(text, sizeof(text), "> Motor %u",
					 (unsigned int)system_setup_menu_dta.motor + 1u);
			system_display_lines("MENU 1 - MOTOR", text);
			break;

		case MENU_LEVEL_PARAMETER:
			switch (system_setup_menu_dta.parameter)
			{
				case SYSTEM_PARAMETER_POWER:
					system_display_lines("MENU 2 - PARAM", "> Power");
					break;

				case SYSTEM_PARAMETER_SPEED:
					system_display_lines("MENU 2 - PARAM", "> Speed");
					break;

				case SYSTEM_PARAMETER_SPIN:
					system_display_lines("MENU 2 - PARAM", "> Spin");
					break;

				default:
					break;
			}
			break;

		case MENU_LEVEL_VALUE:
			snprintf(text, sizeof(text), "M%u VALUE",
					 (unsigned int)system_setup_menu_dta.motor + 1u);
			system_pad_line(line_1, text);

			switch (system_setup_menu_dta.parameter)
			{
				case SYSTEM_PARAMETER_POWER:
					system_pad_line(line_2, draft->power ? "> Power: ON" : "> Power: OFF");
					break;

				case SYSTEM_PARAMETER_SPEED:
					snprintf(text, sizeof(text), "> Speed: %u", (unsigned int)draft->speed);
					system_pad_line(line_2, text);
					break;

				case SYSTEM_PARAMETER_SPIN:
					system_pad_line(line_2, (draft->spin == SYSTEM_SPIN_LEFT) ?
						"> Spin: LEFT" : "> Spin: RIGHT");
					break;

				default:
					system_pad_line(line_2, "");
					break;
			}

			put_event_task_display(0, 0, line_1);
			put_event_task_display(0, 1, line_2);
			break;

		default:
			break;
	}
}

static void system_display_lines(const char *line_1, const char *line_2)
{
	char padded_line_1[17];
	char padded_line_2[17];

	system_pad_line(padded_line_1, line_1);
	system_pad_line(padded_line_2, line_2);
	put_event_task_display(0, 0, padded_line_1);
	put_event_task_display(0, 1, padded_line_2);
}

static void system_pad_line(char output[17], const char *text)
{
	uint32_t index = 0;

	while (index < 16u)
	{
		output[index++] = ' ';
	}
	output[16] = '\0';

	index = 0;
	while ((index < 16u) && ('\0' != text[index]))
	{
		output[index] = text[index];
		index++;
	}
}

static void task_system_set_mode(task_system_mode_t mode)
{
	g_task_system_mode = mode;
}
