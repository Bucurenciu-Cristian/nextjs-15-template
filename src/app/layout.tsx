// app/layout.tsx
import { ClerkProvider } from '@clerk/nextjs';
import { Inter, Poppins } from 'next/font/google';
import { Toaster } from 'react-hot-toast';

import MainFooter from '@/components/Footer';
import MainNavbar from '@/components/Navbar';
import { QueryProvider } from '@/providers/query';
import { ThemeProvider } from '@/providers/theme';
import '@/styles/globals.css';
import type { ChildrenProps } from '@/types';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter',
  adjustFontFallback: false,
});

const poppins = Poppins({
  weight: ['400', '500', '600', '700'],
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-poppins',
});

export const metadata = {
  title: 'Next.js Template | Professional Starter Template',
  description:
    'A highly opinionated and production-ready Next.js 15 template with TypeScript, Tailwind CSS, ESLint, Prettier, Husky, and comprehensive SEO optimization.',
  keywords:
    'next.js, template, typescript, tailwind css, eslint, prettier, husky, seo, nextjs 15, react, web development',
  metadataBase: new URL('https://your-domain.com'),
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: 'https://your-domain.com',
    title: 'Next.js Template | Professional Starter Template',
    description:
      'Production-ready Next.js 15 template with all the essential tools',
    siteName: 'Next.js Template',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Next.js Template',
    description:
      'Production-ready Next.js 15 template with all the essential tools',
  },
};

function RootLayoutContent({ children }: ChildrenProps) {
  return (
    
      <html lang="en" suppressHydrationWarning className="overflow-x-hidden">
      <body
        className={`${inter.variable} ${poppins.variable} font-sans antialiased overflow-x-hidden`}
      >
      <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
        <QueryProvider>
          <div className="flex min-h-screen bg-[var(--background)] w-full overflow-x-hidden">
            <div className="flex-1 flex flex-col w-full">
              <MainNavbar />
              <main className="flex-1 w-full overflow-x-hidden">
                {children}
              </main>
              <MainFooter />
            </div>
          </div>
          <Toaster
            position="bottom-right"
            toastOptions={{
              className:
                'bg-[var(--card)] text-[var(--foreground)] border-[var(--border)]',
              duration: 3000,
            }}
          />
        </QueryProvider>
          </ThemeProvider>
        </body>
      </html>
  );
}

export default function RootLayout({ children }: ChildrenProps) {
  return (
    <ClerkProvider>
    <html lang="en" suppressHydrationWarning className="overflow-x-hidden">
      <body
        className={`${inter.variable} ${poppins.variable} font-sans antialiased overflow-x-hidden`}
      >
        <RootLayoutContent>{children}</RootLayoutContent>
      </body>
    </html>
    </ClerkProvider>
  );
}
