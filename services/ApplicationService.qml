pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick


// Code is based on fzf type searching 
Singleton {
    readonly property var applications: DesktopEntries.applications

    function fuzzyScore(text, query) {
        if (query.length === 0) return 0
        if (text.length === 0) return -1

        let qi = 0
        let score = 0
        let prevMatchIndex = -1
        let firstMatchIndex = -1

        for (let ti = 0; ti < text.length && qi < query.length; ti++) {
            if (text[ti] === query[qi]) {
                if (firstMatchIndex === -1) firstMatchIndex = ti

                if (prevMatchIndex !== -1) {
                    const gap = ti - prevMatchIndex - 1
                    score += gap
                } else {
                    score += ti
                }

                if (ti === 0 || text[ti - 1] === ' ' || text[ti - 1] === '-') {
                    score -= 3
                }

                prevMatchIndex = ti
                qi++
            }
        }

        if (qi < query.length) return -1
        return score
    }

    function scoreApp(app, query) {
        const name = app.name.toLowerCase()

        if (name === query) return 0
        if (name.startsWith(query)) return 1 + (name.length - query.length) * 0.01

        const nameScore = fuzzyScore(name, query)
        const generic = app.genericName ? app.genericName.toLowerCase() : ""
        const genericScore = generic.length > 0 ? fuzzyScore(generic, query) : -1

        let best = -1
        if (nameScore !== -1) best = nameScore + 10 
        if (genericScore !== -1) {
            const weighted = genericScore + 50
            if (best === -1 || weighted < best) best = weighted
        }
        return best
    }

    function search(query) {
        if (query.length === 0) {
            return applications.values.slice().sort((a, b) => a.name.localeCompare(b.name))
        }

        const q = query.toLowerCase()
        const scored = []

        for (const app of applications.values) {
            const score = scoreApp(app, q)
            if (score !== -1) scored.push({ app, score })
        }

        scored.sort((a, b) => {
            if (a.score !== b.score) return a.score - b.score
            return a.app.name.localeCompare(b.app.name)
        })

        return scored.map(s => s.app)
    }
}
