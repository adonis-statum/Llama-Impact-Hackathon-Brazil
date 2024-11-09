'use client';

import React, { useState } from 'react';
import { Card } from '@/components/ui/card';
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import * as z from 'zod';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { Button } from '@/components/ui/button';

interface ContactInformation {
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
}

interface WorkExperience {
  jobTitle: string;
  companyName: string;
  datesOfEmployment: string;
  briefDescription: string;
}

interface Education {
  degree: string;
  institution: string;
  datesOfAttendance: string;
  briefDescription: string;
}

interface Skills {
  skillName: string;
  levelOfProficiency: string;
}

const formSchema = z.object({
  firstName: z.string().min(2, {
    message: 'First name must be at least 2 characters.',
  }),
  lastName: z.string().min(2, {
    message: 'Last name must be at least 2 characters.',
  }),
  email: z.string().email({
    message: 'Invalid email address.',
  }),
  phone: z.string().min(10, {
    message: 'Phone number must be at least 10 characters.',
  }),
});

const ResumeGeneratorForm = () => {
  const form = useForm({
    resolver: zodResolver(formSchema),
  });

  const onSubmit = async (data: unknown) => {
    // Handle form submission
  };

  const [contactInformation, setContactInformation] = useState<ContactInformation>({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
  });

  const [workExperience, setWorkExperience] = useState<WorkExperience[]>([
    {
      jobTitle: '',
      companyName: '',
      datesOfEmployment: '',
      briefDescription: '',
    },
  ]);

  const [education, setEducation] = useState<Education[]>([
    {
      degree: '',
      institution: '',
      datesOfAttendance: '',
      briefDescription: '',
    },
  ]);

  const [skills, setSkills] = useState<Skills[]>([
    {
      skillName: '',
      levelOfProficiency: '',
    },
  ]);

  const handleContactInformationChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setContactInformation({
      ...contactInformation,
      [event.target.name]: event.target.value,
    });
  };

  const handleWorkExperienceChange = (
    index: number,
    event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>
  ) => {
    const newWorkExperience = [...workExperience];
    newWorkExperience[index][event.target.name as keyof WorkExperience] = event.target.value;
    setWorkExperience(newWorkExperience);
  };

  const handleEducationChange = (index: number, event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => {
    const newEducation = [...education];
    newEducation[index][event.target.name as keyof Education] = event.target.value;
    setEducation(newEducation);
  };

  const handleSkillsChange = (index: number, event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => {
    const newSkills = [...skills];
    newSkills[index][event.target.name as keyof Skills] = event.target.value;
    setSkills(newSkills);
  };

  const handleAddWorkExperience = () => {
    setWorkExperience([
      ...workExperience,
      {
        jobTitle: '',
        companyName: '',
        datesOfEmployment: '',
        briefDescription: '',
      },
    ]);
  };

  const handleAddEducation = () => {
    setEducation([
      ...education,
      {
        degree: '',
        institution: '',
        datesOfAttendance: '',
        briefDescription: '',
      },
    ]);
  };

  const handleAddSkills = () => {
    setSkills([
      ...skills,
      {
        skillName: '',
        levelOfProficiency: '',
      },
    ]);
  };

  const handleGenerateResume = () => {
    // TO DO: generate resume based on form data
  };
  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className='space-y-8'>
        <FormField
          control={form.control}
          name='firstName'
          render={({ field }) => (
            <FormItem>
              <FormLabel>First Name</FormLabel>
              <FormControl>
                <Input placeholder='John' {...field} />
              </FormControl>
              <FormDescription>This is your first name.</FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name='lastName'
          render={({ field }) => (
            <FormItem>
              <FormLabel>Last Name</FormLabel>
              <FormControl>
                <Input placeholder='Doe' {...field} />
              </FormControl>
              <FormDescription>This is your last name.</FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name='email'
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input placeholder='john.doe@example.com' {...field} />
              </FormControl>
              <FormDescription>This is your email address.</FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name='phone'
          render={({ field }) => (
            <FormItem>
              <FormLabel>Phone</FormLabel>
              <FormControl>
                <Input placeholder='(123) 456-7890' {...field} />
              </FormControl>
              <FormDescription>This is your phone number.</FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type='submit'>Submit</Button>
      </form>
    </Form>
  );
};

export default ResumeGeneratorForm;
