import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';


import { auth } from '@clerk/nextjs/server'

import { Roles } from '@/types/globals'
import { log } from 'winston';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const myLoader = ({ src }: any) => {
  return src;
};

// display numbers with comma (form string)
export const displayNumbers = (num: number): string =>
  num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');


export const checkRole = async (role: Roles) => {
  const { sessionClaims } = await auth()
  console.log(sessionClaims?.metadata.role, role)
  return sessionClaims?.metadata.role === role
}
