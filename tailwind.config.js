/** Конфиг Tailwind для сборки статичного CSS (вместо Play CDN) */
module.exports = {
    content: ["./index.html"],
    theme: {
        extend: {
            colors: {
                gold: {
                    400: '#fbbf24',
                    500: '#f59e0b',
                    600: '#d97706',
                },
                dark: {
                    800: '#1e293b',
                    900: '#0f172a',
                    950: '#020617',
                }
            },
            fontFamily: {
                sans: ['Montserrat', 'sans-serif'],
                serif: ['Playfair Display', 'serif'],
            }
        }
    },
    plugins: [],
}
