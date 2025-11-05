import type { Schema, Struct } from '@strapi/strapi';

export interface SectionHomepageContentSection extends Struct.ComponentSchema {
  collectionName: 'components_section_homepage_content_sections';
  info: {
    displayName: 'Homepage Content Section';
    icon: 'bulletList';
  };
  attributes: {
    category: Schema.Attribute.Relation<'oneToOne', 'api::category.category'>;
    enable: Schema.Attribute.Boolean & Schema.Attribute.DefaultTo<false>;
    enableHighlight: Schema.Attribute.Boolean &
      Schema.Attribute.DefaultTo<false>;
    enableNavbar: Schema.Attribute.Boolean & Schema.Attribute.DefaultTo<false>;
    icon: Schema.Attribute.Text;
    navbarName: Schema.Attribute.String & Schema.Attribute.Unique;
    sectionName: Schema.Attribute.String &
      Schema.Attribute.Required &
      Schema.Attribute.Unique;
    size: Schema.Attribute.Integer &
      Schema.Attribute.SetMinMax<
        {
          max: 9;
          min: 3;
        },
        number
      > &
      Schema.Attribute.DefaultTo<4>;
  };
}

export interface SectionHomepageHeroSection extends Struct.ComponentSchema {
  collectionName: 'components_section_homepage_hero_sections';
  info: {
    displayName: 'Homepage hero section';
    icon: 'picture';
  };
  attributes: {
    enable: Schema.Attribute.Boolean & Schema.Attribute.DefaultTo<true>;
    heroImage: Schema.Attribute.Media<'images' | 'files' | 'videos'>;
    linkToPost: Schema.Attribute.Boolean & Schema.Attribute.DefaultTo<false>;
    linkUrl: Schema.Attribute.String;
    post: Schema.Attribute.Relation<'oneToOne', 'api::post.post'>;
    subTitle: Schema.Attribute.String &
      Schema.Attribute.SetMinMaxLength<{
        maxLength: 60;
      }>;
    title: Schema.Attribute.String &
      Schema.Attribute.Required &
      Schema.Attribute.SetMinMaxLength<{
        maxLength: 60;
      }>;
  };
}

declare module '@strapi/strapi' {
  export module Public {
    export interface ComponentSchemas {
      'section.homepage-content-section': SectionHomepageContentSection;
      'section.homepage-hero-section': SectionHomepageHeroSection;
    }
  }
}
