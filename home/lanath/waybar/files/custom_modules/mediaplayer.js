#!/usr/bin/env node

const { exec } = require('node:child_process')

const promisify =
	(func) =>
	(...args) =>
		new Promise((res, rej) =>
			func(...args, (err, out) => {
				if (err) {
					rej(err)
				}
				if (typeof out === 'string') return res(out.trim())
				return res(out.trim())
			})
		)

const toHoursAndMinutes = (totalSeconds) => {
	const totalMinutes = Math.floor(totalSeconds / 60)

	const seconds = Math.floor(totalSeconds % 60)
	const hours = Math.floor(totalMinutes / 60)
	const minutes = totalMinutes % 60

	return { h: hours, m: minutes, s: seconds }
}

const formatTime = ({ h, m, s }) => `${h ? `${h}:` : ''}${m}:${s >= 10 ? s : `0${s}`}`

const pexec = promisify(exec)

const run = async () => {
	try {
		const artist = await pexec('playerctl metadata artist')
		const title = await pexec('playerctl metadata title')
		const duration = (await pexec('playerctl metadata mpris:length')) / 1000000
		const position = await pexec('playerctl position')
		const playing = (await pexec('playerctl status')) === 'Playing'

		console.log(
			JSON.stringify({
				text: `${artist} - ${title} - ${formatTime(
					toHoursAndMinutes(position)
				)}/${formatTime(toHoursAndMinutes(duration))}`,
				tooltip: '',
				class: playing ? 'playing' : 'paused',
			})
		)
	} catch (e) {
		console.log(
			JSON.stringify({
				text: '-',
				tooltip: '',
			})
		)
	}
}

setInterval(run, 500)
