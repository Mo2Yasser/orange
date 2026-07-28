import React from "react";
import { AreaChart, Area, XAxis, YAxis, Tooltip, ResponsiveContainer } from "recharts";

interface CollectionChartProps {
  data: { date: string; amount: number }[];
}

export function CollectionChart({ data }: CollectionChartProps) {
  return (
    <div className="h-[200px] w-full">
      <ResponsiveContainer width="100%" height="100%">
        <AreaChart data={data}>
          <XAxis dataKey="date" stroke="#888888" fontSize={12} tickLine={false} axisLine={false} />
          <YAxis stroke="#888888" fontSize={12} tickLine={false} axisLine={false} tickFormatter={(val) => `${val}ج.م`} />
          <Tooltip />
          <Area type="monotone" dataKey="amount" stroke="#f97316" fill="#ffedd5" />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
